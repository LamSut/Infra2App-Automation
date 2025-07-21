#########################
### VPC Configuration ###
#########################

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.b2111933_vpc.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.b2111933_vpc.cidr_block
}

output "vpc_dns_hostnames_enabled" {
  description = "DNS hostnames enabled flag for the VPC"
  value       = aws_vpc.b2111933_vpc.enable_dns_hostnames
}

output "vpc_dns_support_enabled" {
  description = "DNS support enabled flag for the VPC"
  value       = aws_vpc.b2111933_vpc.enable_dns_support
}

output "vpc_tags" {
  description = "Tags associated with the VPC"
  value       = aws_vpc.b2111933_vpc.tags
}


######################
### Public Subnets ###
######################

output "public_subnet_ids" {
  description = "IDs for public subnets"
  value       = [for s in aws_subnet.public_subnets : s.id]
}

output "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  value       = [for s in aws_subnet.public_subnets : s.cidr_block]
}

output "public_subnet_azs" {
  description = "Availability zones for public subnets"
  value       = [for s in aws_subnet.public_subnets : s.availability_zone]
}

output "public_subnet_tags" {
  description = "Tags for each public subnet"
  value       = { for k, s in aws_subnet.public_subnets : k => s.tags }
}

output "public_subnet_count" {
  description = "Count of public subnets"
  value       = length(aws_subnet.public_subnets)
}


########################
### Internet Gateway ###
########################

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "internet_gateway_tags" {
  description = "Tags associated with the Internet Gateway"
  value       = aws_internet_gateway.igw.tags
}

output "gw_vpc_id" {
  description = "The VPC ID associated with the Internet Gateway"
  value       = aws_internet_gateway.igw.vpc_id
}


##########################
### Public Route Table ###
##########################

output "public_rt_id" {
  description = "ID for public route table"
  value       = aws_route_table.public_rt.id
}

output "public_rt_route" {
  description = "Routes configured in public route table"
  value       = aws_route_table.public_rt.route
}

output "public_rt_tags" {
  description = "Tags for public route table"
  value       = aws_route_table.public_rt.tags
}

output "public_rt_association_ids" {
  description = "IDs for associations between public subnets and route tables"
  value       = { for k, assoc in aws_route_table_association.public_rt_assoc : k => assoc.id }
}


#######################
### Security Groups ###
#######################

output "sg_ids" {
  description = "IDs for security groups"
  value       = { for sg_name, sg in aws_security_group.security_groups : sg_name => sg.id }
}

output "sg_icmp_rule_ids" {
  description = "IDs for the ICMP self-referencing security group rules"
  value       = { for key, rule in aws_security_group_rule.sg_icmp : key => rule.id }
}

output "sg_icmp_rule_keys" {
  description = "The keys of ICMP SG rules being created"
  value       = keys(aws_security_group_rule.sg_icmp)
}

output "ingress_rule_ids" {
  description = "IDs of all generated ingress rules"
  value       = { for k, r in aws_security_group_rule.ingress_rules : k => r.id }
}

output "egress_rule_ids" {
  description = "IDs of all generated egress rules"
  value       = { for k, r in aws_security_group_rule.egress_rules : k => r.id }
}

output "sg_linux_ingress_ports" {
  description = "Ingress ports of security group for Linux instances"
  value = [
    for k, r in aws_security_group_rule.ingress_rules :
    r.from_port if split("-", k)[0] == "sg_linux"
  ]
}

output "sg_windows_ingress_ports" {
  description = "Ingress ports of security group for Windows instances"
  value = [
    for k, r in aws_security_group_rule.ingress_rules :
    r.from_port if split("-", k)[0] == "sg_windows"
  ]
}

# #######################
# ### Private Subnets ###
# #######################

# output "private_subnet_ids" {
#   description = "IDs for private subnets"
#   value       = values(aws_subnet.private_subnets)[*].id
# }

# output "private_subnet_cidrs" {
#   description = "CIDR blocks for private subnets"
#   value       = values(aws_subnet.private_subnets)[*].cidr_block
# }

# output "private_subnet_azs" {
#   description = "Availability zones for private subnets"
#   value       = values(aws_subnet.private_subnets)[*].availability_zone
# }

# output "private_subnet_tags" {
#   description = "Tags for each private subnet"
#   value       = { for key, subnet in aws_subnet.private_subnets : key => subnet.tags }
# }

# output "private_subnet_count" {
#   description = "Count of private subnets"
#   value       = length(aws_subnet.private_subnets)
# }


# #########################
# ### NAT Configuration ###
# #########################

# output "nat_eip_public_ip" {
#   description = "Elastic IP address assigned to the NAT Gateway"
#   value       = aws_eip.nat_eip.public_ip
# }

# output "nat_gateway_id" {
#   description = "ID of the NAT Gateway"
#   value       = aws_nat_gateway.nat_gw.id
# }

# output "nat_gateway_allocation_id" {
#   description = "Allocation ID for the NAT Gateway"
#   value       = aws_nat_gateway.nat_gw.allocation_id
# }

# output "nat_gateway_subnet_id" {
#   description = "Subnet ID where the NAT Gateway is deployed"
#   value       = aws_nat_gateway.nat_gw.subnet_id
# }

# output "nat_gateway_tags" {
#   description = "Tags associated with the NAT Gateway"
#   value       = aws_nat_gateway.nat_gw.tags
# }


# ###########################
# ### Private Route Table ###
# ###########################

# output "private_rt_id" {
#   description = "ID of the private route table"
#   value       = aws_route_table.private_rt.id
# }

# output "private_rt_route" {
#   description = "Route configured in the private route table"
#   value       = aws_route_table.private_rt.route
# }

# output "private_rt_tags" {
#   description = "Tags associated with the private route table"
#   value       = aws_route_table.private_rt.tags
# }

# output "private_rt_association_ids" {
#   description = "IDs for associations between private subnets and the route table"
#   value       = { for key, assoc in aws_route_table_association.private_rt_assoc : key => assoc.id }
# }
