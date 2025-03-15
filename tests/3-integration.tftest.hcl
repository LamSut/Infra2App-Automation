run "vpc_integration_test" {
  command = apply

  # VPC
  assert {
    condition     = module.vpc.vpc_id != ""
    error_message = "VPC ID must not be empty."
  }
  assert {
    condition     = module.vpc.vpc_cidr != ""
    error_message = "VPC CIDR block must be defined."
  }
  assert {
    condition     = module.vpc.vpc_dns_hostnames_enabled != null
    error_message = "VPC DNS hostnames enabled flag must be set."
  }
  assert {
    condition     = module.vpc.vpc_dns_support_enabled != null
    error_message = "VPC DNS support enabled flag must be set."
  }

  # Internet Gateway
  assert {
    condition     = module.vpc.internet_gateway_id != ""
    error_message = "Internet Gateway must be attached to the VPC."
  }
  assert {
    condition     = module.vpc.internet_gateway_tags != {}
    error_message = "Internet Gateway tags should be present."
  }
  assert {
    condition     = module.vpc.gw_vpc_id == module.vpc.vpc_id
    error_message = "Must attach this gateway to VPC!"
  }

  # Public Subnet
  assert {
    condition     = length(module.vpc.public_subnet_ids) > 0
    error_message = "At least one public subnet is required."
  }
  assert {
    condition     = length(module.vpc.public_subnet_ids) == module.vpc.public_subnet_count
    error_message = "Public subnet count should match the number of public subnet IDs."
  }
  assert {
    condition     = length(module.vpc.public_subnet_cidrs) == length(module.vpc.public_subnet_ids)
    error_message = "Every public subnet must have an associated CIDR block."
  }
  assert {
    condition     = length(module.vpc.public_subnet_azs) == length(module.vpc.public_subnet_ids)
    error_message = "Every public subnet must be in an availability zone."
  }

  # Public Route Table
  assert {
    condition     = length(module.vpc.public_route_table_ids) > 0
    error_message = "At least one public route table must exist."
  }
  assert {
    condition     = length(keys(module.vpc.public_route_table_association_ids)) > 0
    error_message = "Public subnets must be associated with a route table."
  }

  # NAT Gateway
  assert {
    condition     = module.vpc.nat_eip_public_ip != ""
    error_message = "NAT Gateway Elastic IP must be assigned."
  }
  assert {
    condition     = module.vpc.nat_gateway_id != ""
    error_message = "NAT Gateway must be deployed."
  }
  assert {
    condition     = module.vpc.nat_gateway_allocation_id != ""
    error_message = "NAT Gateway allocation ID must be available."
  }
  assert {
    condition     = module.vpc.nat_gateway_subnet_id != ""
    error_message = "NAT Gateway must be associated with a subnet."
  }

  # Private Subnet
  assert {
    condition     = length(module.vpc.private_subnet_ids) > 0
    error_message = "At least one private subnet is required."
  }
  assert {
    condition     = length(module.vpc.private_subnet_ids) == module.vpc.private_subnet_count
    error_message = "Private subnet count should match the number of private subnet IDs."
  }
  assert {
    condition     = length(module.vpc.private_subnet_cidrs) == length(module.vpc.private_subnet_ids)
    error_message = "Every private subnet must have an associated CIDR block."
  }
  assert {
    condition     = length(module.vpc.private_subnet_azs) == length(module.vpc.private_subnet_ids)
    error_message = "Every private subnet must be in an availability zone."
  }

  # Private Route Table
  assert {
    condition     = module.vpc.private_route_table_id != ""
    error_message = "Private route table ID must be defined."
  }
  assert {
    condition     = length(module.vpc.private_route_table_association_ids) > 0
    error_message = "Private subnets must be associated with the private route table."
  }

  # Security Group
  assert {
    condition     = length(keys(module.vpc.sg_ids)) > 0
    error_message = "There must be at least one security group."
  }
  assert {
    condition     = length(keys(module.vpc.security_group_ingress_rules)) > 0
    error_message = "Ingress rules should be defined for security groups."
  }
  assert {
    condition     = length(keys(module.vpc.security_group_egress_rules)) > 0
    error_message = "Egress rules should be defined for security groups."
  }
}

run "ec2_integration_test" {
  command = apply

  # Amazon Linux instance
  assert {
    condition     = length(module.ec2.amazon_instance_ids) > 0
    error_message = "There should be at least one Amazon Linux instance."
  }
  assert {
    condition     = length(module.ec2.amazon_public_ips) == length(module.ec2.amazon_instance_ids)
    error_message = "Every Amazon Linux instance must have a public IP."
  }
  assert {
    condition     = length(module.ec2.amazon_private_ips) == length(module.ec2.amazon_instance_ids)
    error_message = "Every Amazon Linux instance must have a private IP."
  }
  assert {
    condition     = length(module.ec2.amazon_public_dns) == length(module.ec2.amazon_instance_ids)
    error_message = "Every Amazon Linux instance must have a public DNS."
  }
  assert {
    condition     = length(module.ec2.amazon_private_dns) == length(module.ec2.amazon_instance_ids)
    error_message = "Every Amazon Linux instance must have a private DNS."
  }
  assert {
    condition     = length(module.ec2.amazon_instance_ami) == length(module.ec2.amazon_instance_ids)
    error_message = "Every Amazon Linux instance must have an AMI defined."
  }
  assert {
    condition     = length(module.ec2.amazon_instance_type) == length(module.ec2.amazon_instance_ids)
    error_message = "Every Amazon Linux instance must have an instance type defined."
  }
  assert {
    condition     = length(module.ec2.amazon_key_name) == length(module.ec2.amazon_instance_ids)
    error_message = "Every Amazon Linux instance must have a key pair name defined."
  }
  assert {
    condition     = length(module.ec2.amazon_subnet_id) == length(module.ec2.amazon_instance_ids)
    error_message = "Every Amazon Linux instance must be associated with a subnet."
  }
  assert {
    condition     = length(module.ec2.amazon_security_group_ids) == length(module.ec2.amazon_instance_ids)
    error_message = "Every Amazon Linux instance must have security groups attached."
  }

  # Ubuntu instance
  assert {
    condition     = length(module.ec2.ubuntu_instance_ids) > 0
    error_message = "There should be at least one Ubuntu instance."
  }
  assert {
    condition     = length(module.ec2.ubuntu_public_ips) == length(module.ec2.ubuntu_instance_ids)
    error_message = "Every Ubuntu instance must have a public IP."
  }
  assert {
    condition     = length(module.ec2.ubuntu_private_ips) == length(module.ec2.ubuntu_instance_ids)
    error_message = "Every Ubuntu instance must have a private IP."
  }
  assert {
    condition     = length(module.ec2.ubuntu_public_dns) == length(module.ec2.ubuntu_instance_ids)
    error_message = "Every Ubuntu instance must have a public DNS."
  }
  assert {
    condition     = length(module.ec2.ubuntu_private_dns) == length(module.ec2.ubuntu_instance_ids)
    error_message = "Every Ubuntu instance must have a private DNS."
  }
  assert {
    condition     = length(module.ec2.ubuntu_instance_ami) == length(module.ec2.ubuntu_instance_ids)
    error_message = "Every Ubuntu instance must have an AMI defined."
  }
  assert {
    condition     = length(module.ec2.ubuntu_instance_type) == length(module.ec2.ubuntu_instance_ids)
    error_message = "Every Ubuntu instance must have an instance type defined."
  }
  assert {
    condition     = length(module.ec2.ubuntu_key_name) == length(module.ec2.ubuntu_instance_ids)
    error_message = "Every Ubuntu instance must have a key pair name defined."
  }
  assert {
    condition     = length(module.ec2.ubuntu_subnet_id) == length(module.ec2.ubuntu_instance_ids)
    error_message = "Every Ubuntu instance must be associated with a subnet."
  }
  assert {
    condition     = length(module.ec2.ubuntu_security_group_ids) == length(module.ec2.ubuntu_instance_ids)
    error_message = "Every Ubuntu instance must have security groups attached."
  }

  # Windows instance
  assert {
    condition     = length(module.ec2.windows_instance_ids) > 0
    error_message = "There should be at least one Windows instance."
  }
  assert {
    condition     = length(module.ec2.windows_public_ips) == length(module.ec2.windows_instance_ids)
    error_message = "Every Windows instance must have a public IP."
  }
  assert {
    condition     = length(module.ec2.windows_private_ips) == length(module.ec2.windows_instance_ids)
    error_message = "Every Windows instance must have a private IP."
  }
  assert {
    condition     = length(module.ec2.windows_public_dns) == length(module.ec2.windows_instance_ids)
    error_message = "Every Windows instance must have a public DNS."
  }
  assert {
    condition     = length(module.ec2.windows_private_dns) == length(module.ec2.windows_instance_ids)
    error_message = "Every Windows instance must have a private DNS."
  }
  assert {
    condition     = length(module.ec2.windows_instance_ami) == length(module.ec2.windows_instance_ids)
    error_message = "Every Windows instance must have an AMI defined."
  }
  assert {
    condition     = length(module.ec2.windows_instance_type) == length(module.ec2.windows_instance_ids)
    error_message = "Every Windows instance must have an instance type defined."
  }
  assert {
    condition     = length(module.ec2.windows_key_name) == length(module.ec2.windows_instance_ids)
    error_message = "Every Windows instance must have a key pair name defined."
  }
  assert {
    condition     = length(module.ec2.windows_subnet_id) == length(module.ec2.windows_instance_ids)
    error_message = "Every Windows instance must be associated with a subnet."
  }
  assert {
    condition     = length(module.ec2.windows_security_group_ids) == length(module.ec2.windows_instance_ids)
    error_message = "Every Windows instance must have security groups attached."
  }
}
