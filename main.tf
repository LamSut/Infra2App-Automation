module "vpc" {
  source = "./vpc"
}

module "ec2" {
  source         = "./ec2"
  subnet         = module.vpc.public_subnet_ids
  security_group = module.vpc.security_group_id
}
