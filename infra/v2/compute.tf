module "kind_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name                    = "kind-instance"
  instance_type           = "t3.medium"
  key_name                = var.key_name
  monitoring              = true
  vpc_security_group_ids  = [aws_security_group.kind_cluster_sg.id]
  subnet_id               = module.vpc.private_subnets[0]
  associate_public_ip_address = true

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

resource "aws_ebs_volume" "this" {
  availability_zone = module.vpc.azs[0]
  size              = 30
  tags = {
    Name = "MySQL-Volume"
  }
}

resource "aws_volume_attachment" "this" {
  instance_id = module.kind_instance.id
  volume_id   = aws_ebs_volume.this.id
  device_name = "/dev/xvdf"
}
