# VPC
resource "aws_vpc" "b2111933_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "b2111933_vpc"
  }
}

# Public Subnets
resource "aws_subnet" "public_subnets" {
  for_each                = { for idx, subnet in var.public_subnets : idx => subnet }
  vpc_id                  = aws_vpc.b2111933_vpc.id
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = true
  availability_zone       = each.value.availability_zone

  tags = {
    Name = "public_subnet_${each.key}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.b2111933_vpc.id

  tags = {
    Name = "vpc_igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.b2111933_vpc.id

  route {
    cidr_block = var.default_cidr
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_rt"
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  for_each = aws_subnet.public_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "nat_eip"
  }
}

# Private Subnets
resource "aws_subnet" "private_subnets" {
  for_each                = { for idx, subnet in var.private_subnets : idx => subnet }
  vpc_id                  = aws_vpc.b2111933_vpc.id
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = false
  availability_zone       = each.value.availability_zone

  tags = {
    Name = "private_subnet_${each.key}"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets["0"].id
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name = "nat_gateway"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.b2111933_vpc.id

  route {
    cidr_block     = var.default_cidr
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "private_rt"
  }
}

resource "aws_route_table_association" "private_rt_assoc" {
  for_each = aws_subnet.private_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}
