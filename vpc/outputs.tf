output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.b2111933_vpc.id
}

output "internet_gateway_id" {
  description = "ID of Internet Gateway"
  value       = aws_internet_gateway.b2111933_vpc_igw.id
}

output "public_subnet_ids" {
  description = "IDs for public subnets"
  value       = values(aws_subnet.public_subnets)[*].id
}

output "public_route_table_ids" {
  description = "IDs for public route tables"
  value       = values(aws_route_table.public_subnet_route_tables)[*].id
}

output "nat_eip_public_ip" {
  description = "Elastic IP address assigned to the NAT Gateway"
  value       = aws_eip.nat_eip.public_ip
}

output "nat_gateway_id" {
  description = "ID of NAT Gateway"
  value       = aws_nat_gateway.nat_gw.id
}

output "private_subnet_ids" {
  description = "IDs for private subnets"
  value       = values(aws_subnet.private_subnets)[*].id
}

output "private_route_table_id" {
  description = "ID of private route table"
  value       = aws_route_table.private_subnet_route_table.id
}

output "sg_ids" {
  description = "IDs for security groups"
  value       = { for sg_name, sg in aws_security_group.security_groups : sg_name => sg.id }
}

