module "vpc" {
  source = "./tf-modules/vpc"
}

module "ec2" {
  source = "./tf-modules/ec2"

  # private_subnet = module.vpc.private_subnet_ids
  public_subnet  = module.vpc.public_subnet_ids
  security_group = module.vpc.sg_ids
}

output "all_public_ips" {
  description = "Public IPs of all instances"

  value = {
    hack       = module.ec2.hack_public_ip
    hack_admin = module.ec2.hack_admin_url # Username: root, Password empty

    pizza       = module.ec2.pizza_public_ip
    pizza_admin = module.ec2.pizza_admin_url

    ec2_amazon  = module.ec2.amazon_public_ips
    ec2_ubuntu  = module.ec2.ubuntu_public_ips
    ec2_windows = module.ec2.windows_public_ips
  }
}
