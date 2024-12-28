output "secret" {
  value = {
    secrets_arn = ""
  }
}

output "api_gateway" {
  value = {
    api_gateway_arn = ""
  }
}

output "vpc" {
  value = {
    id = module.vpc.vpc_id

  }
}

data "aws_security_groups" "application_security_group" {
  filter {
    name = "tag:Layer"
    values = ["APPLICATION"]
  }

  filter {
    name = "tag:Name"
    values = ["ApplicationSecurityGroup"]
  }

  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }
}

output "application_security_group_ids" {
  value = data.aws_security_groups.application_security_group.ids
}

output "application_subnet_ids" {
  value = module.vpc.application_subnet_ids
}

output "vpc_endpoints" {
  description = "Map of VPC endpoints"
  value = module.vpc-interface-endpoints.endpoint_map
}

output "load_balancer_security_group_id" {
  value =  aws_security_group.load_balancer_security_group.id
}

output "database_subnet_ids" {
  value = module.vpc.database_subnet_ids
}

data "aws_security_groups" "database_security_group" {
  filter {
    name = "tag:Layer"
    values = ["DATA"]
  }

  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }
}

output "database_security_group_ids" {
  value = data.aws_security_groups.database_security_group.ids
}