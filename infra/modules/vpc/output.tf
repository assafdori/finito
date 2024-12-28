output "vpc_id" {
  value = aws_vpc.vpc.id
}

data "aws_subnets" "application_private_subnets" {
  filter {
    name = "tag:Layer"
    values = ["APPLICATION"]
  }
}

output "application_subnet_ids" {
  value = data.aws_subnets.application_private_subnets.ids
}


data "aws_route_tables" "application_route_table" {
  filter {
    name = "tag:Layer"
    values = ["APPLICATION"]
  }

  filter {
    name = "tag:Tier"
    values = ["Private"]
  }
}

output "application_route_table_ids" {
  value = data.aws_route_tables.application_route_table.ids
}

data "aws_subnets" "database_private_subnets" {
  filter {
    name = "tag:Layer"
    values = ["DATA"]
  }

  filter {
    name = "tag:Tier"
    values = ["Private"]
  }
}

output "database_subnet_ids" {
  value = data.aws_subnets.database_private_subnets.ids
}