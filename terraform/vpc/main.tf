#########################
### VPC Configuration ###
#########################

resource "aws_vpc" "b2111933_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "b2111933_vpc"
  }
}


######################
### Public Subnets ### 
######################

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


#######################
### Private Subnets ###
#######################

# resource "aws_subnet" "private_subnets" {
#   for_each                = { for idx, subnet in var.private_subnets : idx => subnet }
#   vpc_id                  = aws_vpc.b2111933_vpc.id
#   cidr_block              = each.value.cidr_block
#   map_public_ip_on_launch = false
#   availability_zone       = each.value.availability_zone

#   tags = {
#     Name = "private_subnet_${each.key}"
#   }
# }

# resource "aws_eip" "nat_eip" {
#   domain = "vpc"

#   tags = {
#     Name = "nat_eip"
#   }
# }

# resource "aws_nat_gateway" "nat_gw" {
#   allocation_id = aws_eip.nat_eip.id
#   subnet_id     = aws_subnet.public_subnets["0"].id
#   depends_on    = [aws_internet_gateway.igw]

#   tags = {
#     Name = "nat_gateway"
#   }
# }

# resource "aws_route_table" "private_rt" {
#   vpc_id = aws_vpc.b2111933_vpc.id

#   route {
#     cidr_block     = var.default_cidr
#     nat_gateway_id = aws_nat_gateway.nat_gw.id
#   }

#   tags = {
#     Name = "private_rt"
#   }
# }

# resource "aws_route_table_association" "private_rt_assoc" {
#   for_each = aws_subnet.private_subnets

#   subnet_id      = each.value.id
#   route_table_id = aws_route_table.private_rt.id
# }


#######################
### Security Groups ###
#######################

resource "aws_security_group" "security_groups" {
  for_each = var.security_groups_config

  name        = each.key
  description = each.value.description
  vpc_id      = aws_vpc.b2111933_vpc.id
}

locals {
  sg_ingress = flatten([
    for sg_name, sg in var.security_groups_config : [
      for rule in sg.ingress : {
        sg_name     = sg_name
        from_port   = rule.from_port
        to_port     = rule.to_port
        protocol    = rule.protocol
        cidr_blocks = rule.cidr_blocks
      }
    ]
  ])

  sg_egress = flatten([
    for sg_name, sg in var.security_groups_config : [
      for rule in sg.egress : {
        sg_name     = sg_name
        from_port   = rule.from_port
        to_port     = rule.to_port
        protocol    = rule.protocol
        cidr_blocks = rule.cidr_blocks
      }
    ]
  ])
}

resource "aws_security_group_rule" "ingress_rules" {
  for_each = { for idx, rule in local.sg_ingress : "${rule.sg_name}-ingress-${idx}" => rule }

  type              = "ingress"
  security_group_id = aws_security_group.security_groups[each.value.sg_name].id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
}

resource "aws_security_group_rule" "egress_rules" {
  for_each = { for idx, rule in local.sg_egress : "${rule.sg_name}-egress-${idx}" => rule }

  type              = "egress"
  security_group_id = aws_security_group.security_groups[each.value.sg_name].id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
}

resource "aws_security_group_rule" "sg_icmp" {
  for_each                 = toset(["sg_linux", "sg_windows"])
  type                     = "ingress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "icmp"
  security_group_id        = aws_security_group.security_groups[each.value].id
  source_security_group_id = aws_security_group.security_groups[each.value].id
}
