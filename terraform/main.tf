module "vpc" {
  source = "./vpc"
}

module "ec2" {
  source        = "./ec2"
  public_subnet = module.vpc.public_subnet_ids
  // private_subnet = module.vpc.private_subnet_ids
  security_group = module.vpc.sg_ids
}

output "all_public_ips" {
  description = "Public IPs of all instances"
  value = {
    hack  = module.ec2.hack_public_ip
    pizza = module.ec2.pizza_public_ip

    # Public IPs for different OS instances
    amazon  = module.ec2.amazon_public_ips
    ubuntu  = module.ec2.ubuntu_public_ips
    windows = module.ec2.windows_public_ips
  }
}
