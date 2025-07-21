########################
### Networking Tests ###
########################

run "integration_network_tests" {
  command = apply

  assert {
    condition     = module.vpc.vpc_id != ""
    error_message = "VPC must be created and have a valid ID."
  }

  assert {
    condition     = can(regex("^10\\.0\\.", module.vpc.vpc_cidr))
    error_message = "VPC CIDR should start with 10.0."
  }

  assert {
    condition     = module.vpc.public_subnet_count > 0
    error_message = "At least one public subnet must exist."
  }

  assert {
    condition     = alltrue([for id in module.vpc.public_subnet_ids : can(length(id) > 0)])
    error_message = "Each public subnet must have a valid ID."
  }

  assert {
    condition     = module.vpc.internet_gateway_id != ""
    error_message = "Internet Gateway must be created."
  }

  assert {
    condition     = module.vpc.gw_vpc_id == module.vpc.vpc_id
    error_message = "Internet Gateway must be attached to the correct VPC."
  }

  assert {
    condition     = module.vpc.public_rt_id != ""
    error_message = "Public route table must exist."
  }

  assert {
    condition     = length(module.vpc.public_rt_route) > 0
    error_message = "Public route table must contain at least one route."
  }

  assert {
    condition     = length(module.vpc.public_rt_association_ids) == module.vpc.public_subnet_count
    error_message = "Each public subnet must be associated with the route table."
  }
}


############################
### Security Group Tests ###
############################

run "integration_sg_tests" {
  command = apply

  assert {
    condition     = alltrue([for id in values(module.vpc.sg_ids) : can(length(id) > 0)])
    error_message = "All security groups must have valid IDs."
  }

  assert {
    condition     = alltrue([for id in values(module.vpc.sg_vpc_ids) : id == module.vpc.vpc_id])
    error_message = "All security groups must be associated with the correct VPC."
  }

  assert {
    condition     = length(module.vpc.sg_icmp_rule_ids) > 0
    error_message = "ICMP rules must be created."
  }

  assert {
    condition     = alltrue([for id in values(module.vpc.ingress_rule_ids) : can(length(id) > 0)])
    error_message = "All ingress rules must have valid IDs."
  }

  assert {
    condition     = alltrue([for id in values(module.vpc.egress_rule_ids) : can(length(id) > 0)])
    error_message = "All egress rules must have valid IDs."
  }
}
