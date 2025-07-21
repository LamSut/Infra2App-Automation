# #############################
# ### VPC Integration Tests ###
# #############################

# run "integration_vpc_tests" {
#   command = apply

#   ########################
#   ### Networking Tests ###
#   ########################

#   assert {
#     condition     = module.vpc.vpc_id != ""
#     error_message = "VPC must be created and have a valid ID."
#   }

#   assert {
#     condition     = can(regex("^10\\.0\\.", module.vpc.vpc_cidr))
#     error_message = "VPC CIDR should start with 10.0."
#   }

#   assert {
#     condition     = module.vpc.public_subnet_count > 0
#     error_message = "At least one public subnet must exist."
#   }

#   assert {
#     condition     = alltrue([for id in module.vpc.public_subnet_ids : can(length(id) > 0)])
#     error_message = "Each public subnet must have a valid ID."
#   }

#   assert {
#     condition     = module.vpc.internet_gateway_id != ""
#     error_message = "Internet Gateway must be created."
#   }

#   assert {
#     condition     = module.vpc.gw_vpc_id == module.vpc.vpc_id
#     error_message = "Internet Gateway must be attached to the correct VPC."
#   }

#   assert {
#     condition     = module.vpc.public_rt_id != ""
#     error_message = "Public route table must exist."
#   }

#   assert {
#     condition     = length(module.vpc.public_rt_route) > 0
#     error_message = "Public route table must contain at least one route."
#   }

#   assert {
#     condition     = length(module.vpc.public_rt_association_ids) == module.vpc.public_subnet_count
#     error_message = "Each public subnet must be associated with the route table."
#   }


#   ############################
#   ### Security Group Tests ###
#   ############################

#   assert {
#     condition     = alltrue([for id in values(module.vpc.sg_ids) : can(length(id) > 0)])
#     error_message = "All security groups must have valid IDs."
#   }

#   assert {
#     condition     = alltrue([for id in values(module.vpc.sg_vpc_ids) : id == module.vpc.vpc_id])
#     error_message = "All security groups must be associated with the correct VPC."
#   }

#   assert {
#     condition     = length(module.vpc.sg_icmp_rule_ids) > 0
#     error_message = "ICMP rules must be created."
#   }

#   assert {
#     condition     = alltrue([for id in values(module.vpc.ingress_rule_ids) : can(length(id) > 0)])
#     error_message = "All ingress rules must have valid IDs."
#   }

#   assert {
#     condition     = alltrue([for id in values(module.vpc.egress_rule_ids) : can(length(id) > 0)])
#     error_message = "All egress rules must have valid IDs."
#   }
# }


# #############################
# ### EC2 Integration Tests ###
# #############################

# run "integration_ec2_tests" {
#   command = apply

#   ##########################
#   ### Hack Instance Test ###
#   ##########################

#   assert {
#     condition     = module.ec2.hack_instance_count == 0 || can(regex("^i-", module.ec2.hack_instance_id))
#     error_message = "Hack instance must have a valid instance ID if it exists."
#   }

#   assert {
#     condition     = module.ec2.hack_instance_count == 0 || contains(module.vpc.public_subnet_ids, module.ec2.hack_subnet_id)
#     error_message = "Hack instance must be in a public subnet created by the VPC module."
#   }

#   assert {
#     condition = module.ec2.hack_instance_count == 0 || alltrue([
#       for sg in module.ec2.hack_security_group_ids : contains(values(module.vpc.sg_ids), sg)
#     ])
#     error_message = "Hack instance must use security groups created by the VPC module."
#   }

#   assert {
#     condition     = module.ec2.hack_instance_count == 0 || can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+$", module.ec2.hack_public_ip))
#     error_message = "Hack instance must have a valid public IP if it exists."
#   }


#   ###########################
#   ### Pizza Instance Test ###
#   ###########################

#   assert {
#     condition     = module.ec2.pizza_instance_count == 0 || can(regex("^i-", module.ec2.pizza_instance_id))
#     error_message = "Pizza instance must have a valid instance ID if it exists."
#   }

#   assert {
#     condition     = module.ec2.pizza_instance_count == 0 || contains(module.vpc.public_subnet_ids, module.ec2.pizza_subnet_id)
#     error_message = "Pizza instance must be in a public subnet created by the VPC module."
#   }

#   assert {
#     condition = module.ec2.pizza_instance_count == 0 || alltrue([
#       for sg in module.ec2.pizza_security_group_ids : contains(values(module.vpc.sg_ids), sg)
#     ])
#     error_message = "Pizza instance must use security groups created by the VPC module."
#   }

#   assert {
#     condition     = module.ec2.pizza_instance_count == 0 || can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+$", module.ec2.pizza_public_ip))
#     error_message = "Pizza instance must have a valid public IP if it exists."
#   }


#   ##############################
#   ### Amazon Linux Instances ###
#   ##############################

#   assert {
#     condition = module.ec2.amazon_instance_count == 0 || alltrue([
#       for id in module.ec2.amazon_instance_ids : can(regex("^i-", id))
#     ])
#     error_message = "All Amazon Linux instances must have valid instance IDs."
#   }

#   assert {
#     condition = module.ec2.amazon_instance_count == 0 || alltrue([
#       for subnet in module.ec2.amazon_subnet_id : contains(module.vpc.public_subnet_ids, subnet)
#     ])
#     error_message = "All Amazon Linux instances must be in VPC subnets created by the VPC module."
#   }

#   assert {
#     condition = module.ec2.amazon_instance_count == 0 || alltrue([
#       for sg in flatten(module.ec2.amazon_security_group_ids) : contains(values(module.vpc.sg_ids), sg)
#     ])
#     error_message = "Amazon Linux instances must use security groups created by the VPC module."
#   }

#   assert {
#     condition = module.ec2.amazon_instance_count == 0 || alltrue([
#       for ip in module.ec2.amazon_public_ips : can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+$", ip))
#     ])
#     error_message = "All Amazon Linux instances must have valid public IPs."
#   }


#   ########################
#   ### Ubuntu Instances ###
#   ########################

#   assert {
#     condition = module.ec2.ubuntu_instance_count == 0 || alltrue([
#       for id in module.ec2.ubuntu_instance_ids : can(regex("^i-", id))
#     ])
#     error_message = "All Ubuntu instances must have valid instance IDs."
#   }

#   assert {
#     condition = module.ec2.ubuntu_instance_count == 0 || alltrue([
#       for subnet in module.ec2.ubuntu_subnet_id : contains(module.vpc.public_subnet_ids, subnet)
#     ])
#     error_message = "All Ubuntu instances must be in VPC subnets created by the VPC module."
#   }

#   assert {
#     condition = module.ec2.ubuntu_instance_count == 0 || alltrue([
#       for sg in flatten(module.ec2.ubuntu_security_group_ids) : contains(values(module.vpc.sg_ids), sg)
#     ])
#     error_message = "Ubuntu instances must use security groups created by the VPC module."
#   }

#   assert {
#     condition = module.ec2.ubuntu_instance_count == 0 || alltrue([
#       for ip in module.ec2.ubuntu_public_ips : can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+$", ip))
#     ])
#     error_message = "All Ubuntu instances must have valid public IPs."
#   }


#   #########################
#   ### Windows Instances ###
#   #########################

#   assert {
#     condition = module.ec2.windows_instance_count == 0 || alltrue([
#       for id in module.ec2.windows_instance_ids : can(regex("^i-", id))
#     ])
#     error_message = "All Windows instances must have valid instance IDs."
#   }

#   assert {
#     condition = module.ec2.windows_instance_count == 0 || alltrue([
#       for subnet in module.ec2.windows_subnet_id : contains(module.vpc.public_subnet_ids, subnet)
#     ])
#     error_message = "All Windows instances must be in VPC subnets created by the VPC module."
#   }

#   assert {
#     condition = module.ec2.windows_instance_count == 0 || alltrue([
#       for sg in flatten(module.ec2.windows_security_group_ids) : contains(values(module.vpc.sg_ids), sg)
#     ])
#     error_message = "Windows instances must use security groups created by the VPC module."
#   }

#   assert {
#     condition = module.ec2.windows_instance_count == 0 || alltrue([
#       for ip in module.ec2.windows_public_ips : can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+$", ip))
#     ])
#     error_message = "All Windows instances must have valid public IPs."
#   }
# }
