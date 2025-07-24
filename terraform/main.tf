######################
### Cloud Provider ###
######################

provider "aws" {
  region = "ap-southeast-1"
}


##################
### VPC Module ###
##################

module "vpc" {
  source = "./tf-modules/vpc"

  default_cidr   = var.default_cidr
  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets
  # private_subnets = var.private_subnets

  security_groups_config = var.security_groups_config
}


##################
### EC2 Module ###
##################

module "ec2" {
  source = "./tf-modules/ec2"

  # private_subnet = module.vpc.private_subnet_ids
  public_subnet  = module.vpc.public_subnet_ids
  security_group = module.vpc.sg_ids

  provision_hack    = var.provision_hack
  provision_pizza   = var.provision_pizza
  provision_amazon  = var.provision_amazon
  provision_ubuntu  = var.provision_ubuntu
  provision_windows = var.provision_windows

  ami_amazon    = data.aws_ami.ami_amazon_2023.id
  ami_ubuntu    = data.aws_ami.ami_ubuntu_2404.id
  ami_windows   = data.aws_ami.ami_windows_2025.id
  instance_free = var.instance_free

  private_key_name = var.private_key_name
  private_key_path = var.private_key_path

  setup_linux   = var.setup_linux
  setup_windows = var.setup_windows

  pb_linux_path   = var.pb_linux_path
  pb_windows_path = var.pb_windows_path
}


###############
### Outputs ###
###############

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
