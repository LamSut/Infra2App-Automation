# Unit tests for VPC and EC2 modules

# VPC tests
run "vpc_tests" {
  command = plan

  # Ensure DNS hostnames and support are enabled
  assert {
    condition     = module.vpc.vpc_dns_hostnames_enabled == true
    error_message = "Must enable DNS hostname resolution!"
  }

  assert {
    condition     = module.vpc.vpc_dns_support_enabled == true
    error_message = "Must enable DNS resolution!"
  }

  # Validate VPC CIDR format (slash must exist)
  assert {
    condition     = length(split("/", module.vpc.vpc_cidr)) > 1
    error_message = "VPC CIDR must be a valid CIDR block!"
  }

  # Public subnets
  assert {
    condition     = module.vpc.public_subnet_count > 0
    error_message = "There must be at least one public subnet!"
  }

  assert {
    condition     = length(module.vpc.public_subnet_ids) == module.vpc.public_subnet_count
    error_message = "public_subnet_ids length must match public_subnet_count!"
  }

  # Private subnets
  # assert {
  #   condition     = module.vpc.private_subnet_count > 0
  #   error_message = "There must be at least one private subnet!"
  # }

  # Security groups and rules
  assert {
    condition     = length(module.vpc.sg_ids) > 0
    error_message = "Security groups must be created!"
  }

  assert {
    condition     = length(module.vpc.sg_icmp_rule_ids) > 0
    error_message = "ICMP rule must be enabled in security groups!"
  }
}


# EC2 tests
run "ec2_tests" {
  command = plan

  assert {
    condition     = module.ec2.amazon_key_name != ""
    error_message = "Amazon Linux instance must have a key pair name!"
  }

  assert {
    condition     = module.ec2.ubuntu_key_name != ""
    error_message = "Ubuntu instance must have a key pair name!"
  }

  assert {
    condition     = module.ec2.windows_key_name != ""
    error_message = "Windows instance must have a key pair name!"
  }
}
