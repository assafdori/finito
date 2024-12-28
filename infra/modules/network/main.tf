# Checklist
#################################################################
# x # VPC link
# x # NACL
# x # Security Group
#################################################################

module "vpc" {
  source = "../vpc"
  vpc_name = var.network_name
  vpc_main_cidr_block = var.vpc_main_cidr_block
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  enable_internet_gateway = true
  enable_dns_hostnames = true
  enable_dns_support = true
  enable_nat_gateway = true
}

#module "vpc-interface-endpoints" {
#  source = "../vpc-endpoint"
#  vpc_id = module.vpc.vpc_id
#  list_of_aws_services_as_interface = ["logs", "secretsmanager", "ecr.api", "ecr.dkr", "sqs"] // TODO: Add configuration for "email-smtp" or "email".  "email-smtp", "email" does not exist in tel-aviv region
#  create_s3_gateway = true
#  route_table_ids = module.vpc.application_route_table_ids
#  subnet_ids = module.vpc.application_subnet_ids
#}

######################################################################################
### APPLICATION SECURITY GROUP
######################################################################################
resource "aws_security_group" "application_security_group" {
  name        = "ApplicationSecurityGroup"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Layer = "APPLICATION"
    Name = "ApplicationSecurityGroup"
  }
}

resource "aws_vpc_security_group_ingress_rule" "application_security_group_ingress_https" {
  security_group_id = aws_security_group.application_security_group.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "application_security_group_ingress_http" {
  security_group_id = aws_security_group.application_security_group.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "application_security_group_egress_https" {
  security_group_id = aws_security_group.application_security_group.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "application_security_group_egress_http" {
  security_group_id = aws_security_group.application_security_group.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "application_security_group_ingress_database" {
  security_group_id = aws_security_group.application_security_group.id
  ip_protocol       = "tcp"
  referenced_security_group_id = aws_security_group.database_security_group.id
  from_port         = var.database_port
  to_port           = var.database_port
}


resource "aws_vpc_security_group_ingress_rule" "application_services_ingress" {
  security_group_id = aws_security_group.application_security_group.id
  ip_protocol       = "tcp"
  referenced_security_group_id = aws_security_group.load_balancer_security_group.id
  from_port         = 8080
  to_port           = 8086
}

resource "aws_vpc_security_group_egress_rule" "application_services_egress" {
  security_group_id = aws_security_group.application_security_group.id
  ip_protocol       = "tcp"
  referenced_security_group_id = aws_security_group.load_balancer_security_group.id
  from_port         = 8080
  to_port           = 8086
}
######################################################################################
### LOAD BALANCER SECURITY GROUP
######################################################################################
resource "aws_security_group" "load_balancer_security_group" {
  name        = "LoadBalancerSecurityGroup"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Layer = "APPLICATION"
    Name = "LoadBalancerSecurityGroup"
  }
}

resource "aws_vpc_security_group_ingress_rule" "load_balancer_security_group_ingress_https" {
  security_group_id = aws_security_group.load_balancer_security_group.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "load_balancer_security_group_ingress_http" {
  security_group_id = aws_security_group.load_balancer_security_group.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "load_balancer_security_group_egress_https" {
  security_group_id = aws_security_group.load_balancer_security_group.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "load_balancer_security_group_egress_http" {
  security_group_id = aws_security_group.load_balancer_security_group.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "load_balancer_application_ingress" {
  security_group_id = aws_security_group.load_balancer_security_group.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  to_port           = 8080
}
resource "aws_vpc_security_group_egress_rule" "load_balancer_application_egress" {
  security_group_id = aws_security_group.load_balancer_security_group.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  to_port           = 8080
}

######################################################################################
### DATABASE SECURITY GROUP
######################################################################################
resource "aws_security_group" "database_security_group" {
  name        = "DatabaseSecurityGroup"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Layer = "DATA"
    Name = "DatabaseSecurityGroup"
  }
}

resource "aws_security_group_rule" "allow_app_sg" {
  type                     = "ingress"
  from_port                = var.database_port
  to_port                  = var.database_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.database_security_group.id
  source_security_group_id = aws_security_group.application_security_group.id
  description              = "Allow traffic from Application Security Group"
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.database_security_group.id
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound traffic"
}
