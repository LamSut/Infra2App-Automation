# # Unit tests for the VPC and EC2 modules

# run "vpc_tests" {
#   command = plan

#   assert {
#     condition     = module.vpc.vpc_dns_hostnames_enabled == true
#     error_message = "Must enable DNS hostname resolution!"
#   }

#   assert {
#     condition     = module.vpc.vpc_dns_support_enabled == true
#     error_message = "Must enable DNS resolution!"
#   }
# }

# run "ec2_tests" {
#   command = plan

#   assert {
#     condition     = module.ec2.amazon_instance_type[0] == "t2.micro"
#     error_message = "Amazon Linux instance must be t2.micro for free tier!"
#   }

#   assert {
#     condition     = module.ec2.ubuntu_instance_type[0] == "t2.micro"
#     error_message = "Ubuntu instance must be t2.micro for free tier!"
#   }

#   assert {
#     condition     = module.ec2.windows_instance_type[0] == "t2.micro"
#     error_message = "Windows instance must be t2.micro for free tier!"
#   }
# }
