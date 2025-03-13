# run "vpc_integration_test" {
#   command = apply

#   // gateway test
#   assert {
#     condition     = module.vpc.gw_vpc_id == module.vpc.vpc_id
#     error_message = "Must attach this gateway to VPC!"
#   }

#   //subnet1 vpc id test
#   assert {
#     condition     = module.vpc.subnet1_vpc_id == module.vpc.vpc_id
#     error_message = "This subnet must be inside the VPC!"
#   }

#   //route_table1 vpc id test
#   assert {
#     condition     = module.vpc.route_table1_vpc_id == module.vpc.vpc_id
#     error_message = "This route table must be inside the VPC!"
#   }

#   //route_table1 gw id test
#   assert {
#     condition     = module.vpc.route_table1_gw_id[0] == module.vpc.gw
#     error_message = "This route table must be attach to the gateway!"
#   }

#   //subnet1 association test
#   assert {
#     condition     = module.vpc.public_subnet1 == module.vpc.association_subnet1 && module.vpc.route_table1 == module.vpc.association_route_table1
#     error_message = "Must attach this subnet to a route table!"
#   }

#   //subnet2 vpc id test
#   assert {
#     condition     = module.vpc.subnet2_vpc_id == module.vpc.vpc_id
#     error_message = "This subnet must be inside the VPC!"
#   }

#   //route_table2 vpc id test
#   assert {
#     condition     = module.vpc.route_table2_vpc_id == module.vpc.vpc_id
#     error_message = "This route table must be inside the VPC!"
#   }

#   //route_table2 gw id test
#   assert {
#     condition     = module.vpc.route_table2_gw_id[0] == module.vpc.gw
#     error_message = "This route table must be attach to the gateway!"
#   }

#   //subnet2 association test
#   assert {
#     condition     = module.vpc.public_subnet2 == module.vpc.association_subnet2 && module.vpc.route_table2 == module.vpc.association_route_table2
#     error_message = "Must attach this subnet to a route table!"
#   }
# }


# run "ec2_integration_tests" {
#   command = apply

#   // amazon network

#   assert {
#     condition = alltrue([
#       for subnet in module.ec2.subnet_amazon : subnet == module.vpc.public_subnet1 || subnet == module.vpc.public_subnet2
#     ])
#     error_message = "Amazon Servers: Invalid subnet!"
#   }

#   assert {
#     condition = alltrue([
#       for sg_list in module.ec2.sg_amazon : alltrue([
#         for sg in sg_list : sg == module.vpc.security_group
#       ])
#     ])
#     error_message = "Amazon Servers: Invalid security group!"
#   }

#   // ubuntu network

#   assert {
#     condition = alltrue([
#       for subnet in module.ec2.subnet_ubuntu : subnet == module.vpc.public_subnet1 || subnet == module.vpc.public_subnet2
#     ])
#     error_message = "Ubuntu Servers: Invalid subnet!"
#   }

#   assert {
#     condition = alltrue([
#       for sg_list in module.ec2.sg_ubuntu : alltrue([
#         for sg in sg_list : sg == module.vpc.security_group
#       ])
#     ])
#     error_message = "Ubuntu Servers: Invalid security group!"
#   }

#   //windows network

#   assert {
#     condition = alltrue([
#       for subnet in module.ec2.subnet_windows : subnet == module.vpc.public_subnet1 || subnet == module.vpc.public_subnet2
#     ])
#     error_message = "Windows Servers: Invalid subnet!"
#   }

#   assert {
#     condition = alltrue([
#       for sg_list in module.ec2.sg_windows : alltrue([
#         for sg in sg_list : sg == module.vpc.security_group
#       ])
#     ])
#     error_message = "Windows Servers: Invalid security group!"
#   }
# }
