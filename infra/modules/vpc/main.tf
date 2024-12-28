# VPC Configuration
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_main_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = {
    Name = var.vpc_name
  }
}

# Public Subnets
resource "aws_subnet" "public_subnet" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnets[count.index].ipv4_cidr_block
  availability_zone = var.public_subnets[count.index].availability_zone

  tags = {
    Name = "${var.public_subnets[count.index].name}_PublicSubnet"
    Tier = "Public"
  }
}

# Private Subnets
resource "aws_subnet" "private_subnet" {
  for_each = { for s in var.private_subnets : s.name => s }

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.ipv4_cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name  = "${each.value.name}_PrivateSubnet"
    Tier  = "Private"
    Layer = each.value.layer
  }
}

# Private Route Tables
resource "aws_route_table" "private_route_table" {
  for_each = { for s in var.private_subnets : s.name => s }

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name  = "${each.value.name}_PrivateRoute"
    Tier  = "Private"
    Layer = each.value.layer
  }

  depends_on = [aws_subnet.private_subnet]
}

# Associate Private Subnets with Private Route Tables
resource "aws_route_table_association" "private_route_table_association" {
  for_each = { for s in var.private_subnets : s.name => s }

  subnet_id      = aws_subnet.private_subnet[each.key].id
  route_table_id = aws_route_table.private_route_table[each.key].id

  depends_on = [aws_subnet.private_subnet, aws_route_table.private_route_table]
}

# Internet Gateway (Conditional)
resource "aws_internet_gateway" "gw" {
  count  = var.enable_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_name}-internet-gateway"
  }
}

# Public Route Table (Conditional)
resource "aws_route_table" "second_rt" {
  count  = var.enable_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw[count.index].id
  }

  tags = {
    Name = "${var.vpc_name}-route-table"
  }
}

# Associate Public Subnets with Public Route Table (Conditional)
resource "aws_route_table_association" "public_subnet_association" {
  count = var.enable_internet_gateway ? length(aws_subnet.public_subnet) : 0

  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.second_rt[0].id  # Reference the first (and only) route table

  depends_on = [aws_route_table.second_rt, aws_subnet.public_subnet]
}


resource "aws_eip" "nat_eip" {
  for_each = var.enable_nat_gateway ? { for s in var.public_subnets : s.availability_zone => s } : {}

  tags = {
    Name = "${var.vpc_name}-nat-eip-${each.key}"
  }
}

locals {
  public_subnet_ids_by_az = {
    for idx, subnet in aws_subnet.public_subnet : subnet.availability_zone => subnet.id
  }
}

resource "aws_nat_gateway" "nat" {
  for_each = var.enable_nat_gateway ? aws_eip.nat_eip : {}

  allocation_id = each.value.id
  subnet_id     = local.public_subnet_ids_by_az[each.key]

  tags = {
    Name = "${var.vpc_name}-nat-gateway-${each.key}"
  }

  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route" "private_nat_route" {
  for_each = var.enable_nat_gateway ? { for s in var.private_subnets : s.name => s } : {}

  route_table_id         = aws_route_table.private_route_table[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[each.value.availability_zone].id

  depends_on = [aws_nat_gateway.nat]
}
