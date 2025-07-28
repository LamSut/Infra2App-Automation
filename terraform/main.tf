###############################
### Terraform Configuration ###
###############################

provider "aws" {
  region = "ap-southeast-1"
}

terraform {
  backend "s3" {
    bucket         = "b2111933-store"
    key            = "b2111933-state"
    region         = "ap-southeast-1"
    dynamodb_table = "b2111933-lock"
  }
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

  hack_playbooks    = var.hack_playbooks
  pizza_playbooks   = var.pizza_playbooks
  amazon_playbooks  = var.amazon_playbooks
  ubuntu_playbooks  = var.ubuntu_playbooks
  windows_playbooks = var.windows_playbooks
}
