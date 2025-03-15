// VPC
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

// Internet Gateway
output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.b2111933_vpc_igw.id
}

output "internet_gateway_tags" {
  description = "Tags associated with the Internet Gateway"
  value       = aws_internet_gateway.b2111933_vpc_igw.tags
}

output "gw_vpc_id" {
  value       = aws_internet_gateway.b2111933_vpc_igw.vpc_id
  description = "The VPC ID associated with the Internet Gateway"
}

// Public Subnet
output "public_subnet_ids" {
  description = "IDs for public subnets"
  value       = values(aws_subnet.public_subnets)[*].id
}

output "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  value       = values(aws_subnet.public_subnets)[*].cidr_block
}

output "public_subnet_azs" {
  description = "Availability zones for public subnets"
  value       = values(aws_subnet.public_subnets)[*].availability_zone
}

output "public_subnet_tags" {
  description = "Tags for each public subnet"
  value       = { for key, subnet in aws_subnet.public_subnets : key => subnet.tags }
}

output "public_subnet_count" {
  description = "Count of public subnets"
  value       = length(aws_subnet.public_subnets)
}

// Public Route Table
output "public_route_table_ids" {
  description = "IDs for public route tables"
  value       = values(aws_route_table.public_subnet_route_tables)[*].id
}

output "public_route_table_routes" {
  description = "Routes configured in each public route table"
  value       = { for key, rt in aws_route_table.public_subnet_route_tables : key => rt.route }
}

output "public_route_table_tags" {
  description = "Tags for each public route table"
  value       = { for key, rt in aws_route_table.public_subnet_route_tables : key => rt.tags }
}

output "public_route_table_association_ids" {
  description = "IDs for associations between public subnets and route tables"
  value       = { for key, assoc in aws_route_table_association.public_subnet_route_table_associations : key => assoc.id }
}

// NAT Gateway
output "nat_eip_public_ip" {
  description = "Elastic IP address assigned to the NAT Gateway"
  value       = aws_eip.nat_eip.public_ip
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.nat_gw.id
}

output "nat_gateway_allocation_id" {
  description = "Allocation ID for the NAT Gateway"
  value       = aws_nat_gateway.nat_gw.allocation_id
}

output "nat_gateway_subnet_id" {
  description = "Subnet ID where the NAT Gateway is deployed"
  value       = aws_nat_gateway.nat_gw.subnet_id
}

output "nat_gateway_tags" {
  description = "Tags associated with the NAT Gateway"
  value       = aws_nat_gateway.nat_gw.tags
}

// Private Subnet
output "private_subnet_ids" {
  description = "IDs for private subnets"
  value       = values(aws_subnet.private_subnets)[*].id
}

output "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  value       = values(aws_subnet.private_subnets)[*].cidr_block
}

output "private_subnet_azs" {
  description = "Availability zones for private subnets"
  value       = values(aws_subnet.private_subnets)[*].availability_zone
}

output "private_subnet_tags" {
  description = "Tags for each private subnet"
  value       = { for key, subnet in aws_subnet.private_subnets : key => subnet.tags }
}

output "private_subnet_count" {
  description = "Count of private subnets"
  value       = length(aws_subnet.private_subnets)
}

// Private Route Table
output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private_subnet_route_table.id
}

output "private_route_table_routes" {
  description = "Routes configured in the private route table"
  value       = aws_route_table.private_subnet_route_table.route
}

output "private_route_table_tags" {
  description = "Tags associated with the private route table"
  value       = aws_route_table.private_subnet_route_table.tags
}

output "private_route_table_association_ids" {
  description = "IDs for associations between private subnets and the route table"
  value       = { for key, assoc in aws_route_table_association.private_subnet_route_table_associations : key => assoc.id }
}

// Security Group
output "sg_ids" {
  description = "IDs for security groups"
  value       = { for sg_name, sg in aws_security_group.security_groups : sg_name => sg.id }
}

output "security_group_ingress_rules" {
  description = "Ingress rules for each security group"
  value       = { for sg_name, sg in aws_security_group.security_groups : sg_name => sg.ingress }
}

output "security_group_egress_rules" {
  description = "Egress rules for each security group"
  value       = { for sg_name, sg in aws_security_group.security_groups : sg_name => sg.egress }
}

output "sg_icmp_rule_ids" {
  description = "IDs for the ICMP security group rules"
  value       = { for key, rule in aws_security_group_rule.sg_icmp : key => rule.id }
}
