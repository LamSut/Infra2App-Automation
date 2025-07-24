#################
### Variables ###
#################

variables {
  default_cidr              = "0.0.0.0/0"
  vpc_cidr                  = "10.0.0.0/16"
  sg_linux_required_ports   = [22, 80, 443]
  sg_windows_required_ports = [80, 443, 3389, 5986]
}


########################
### Networking Tests ###
########################

run "vpc_config_tests" {
  command = plan

  assert {
    condition     = module.vpc.vpc_cidr == var.vpc_cidr
    error_message = "VPC must use the correct CIDR block."
  }

  assert {
    condition     = module.vpc.vpc_dns_hostnames_enabled == true
    error_message = "DNS hostnames must be enabled in the VPC."
  }

  assert {
    condition     = module.vpc.vpc_dns_support_enabled == true
    error_message = "DNS support must be enabled in the VPC."
  }
}

run "vpc_public_tests" {
  command = plan

  assert {
    condition     = module.vpc.public_subnet_count > 0
    error_message = "There must be at least one public subnet configured."
  }

  assert {
    condition     = alltrue([for cidr in module.vpc.public_subnet_cidrs : can(cidrsubnet(var.vpc_cidr, 8, 1))])
    error_message = "All public subnet CIDRs must be valid subnets of the VPC."
  }

  assert {
    condition     = alltrue([for az in module.vpc.public_subnet_azs : startswith(az, "ap-southeast-1")])
    error_message = "All public subnets must be in ap-southeast-1 region."
  }

  assert {
    condition     = module.vpc.internet_gateway_tags != ""
    error_message = "Must have an Internet Gateway."
  }

  assert {
    condition     = module.vpc.public_rt_tags != ""
    error_message = "Must have a Public Route Table."
  }

  assert {
    condition     = length(module.vpc.public_rt_route) > 0
    error_message = "Public route table must contain at least one route."
  }
}


#############################
### Security Groups Tests ###
#############################

run "sg_config_tests" {
  command = plan

  assert {
    condition     = contains(keys(module.vpc.sg_ids), "sg_linux")
    error_message = "Security group for Linux instances must be defined."
  }

  assert {
    condition     = contains(keys(module.vpc.sg_ids), "sg_windows")
    error_message = "Security group for Windows instances must be defined."
  }

  assert {
    condition     = length(module.vpc.ingress_rule_ids) > 0
    error_message = "Security group Ingress rules must be defined."
  }

  assert {
    condition     = length(module.vpc.egress_rule_ids) > 0
    error_message = "Security group Egress rules must be defined."
  }
}

run "sg_linux_tests" {
  command = plan

  assert {
    condition = alltrue([
      for p in var.sg_linux_required_ports : contains(module.vpc.sg_linux_ingress_ports, p)
    ])
    error_message = "Security group for Linux instances must allow ports 22, 80 and 443 for ingress."
  }

  assert {
    condition     = contains(module.vpc.sg_icmp_rule_keys, "sg_linux")
    error_message = "ICMP self-referencing rule must be set for the Linux security group."
  }
}

run "sg_windows_tests" {
  command = plan

  assert {
    condition = alltrue([
      for p in var.sg_windows_required_ports : contains(module.vpc.sg_windows_ingress_ports, p)
    ])
    error_message = "Security group for Windows instances must allow ports 80, 443, 3389 and 5986 for ingress."
  }

  assert {
    condition     = contains(module.vpc.sg_icmp_rule_keys, "sg_windows")
    error_message = "ICMP self-referencing rule must be set for the Windows security group."
  }
}
