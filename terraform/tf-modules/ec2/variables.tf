#####################
### EC2 Instances ###
#####################

variable "deploy_hack" {
  description = "Provision EC2 for Hack Website or not"
  type        = bool
  default     = false
}

variable "deploy_pizza" {
  description = "Provision EC2 for Pizza Website or not"
  type        = bool
  default     = false
}

######################
### VPC Networking ###
######################

variable "security_group" {
  type = map(string)
  default = {
    "sg_linux"   = "sg_linux",
    "sg_windows" = "sg_windows"
  }
}

variable "public_subnet" {}
# variable "private_subnet" {}


#################
### Free AMIs ###
#################

data "aws_ami" "ami_amazon_2023" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "ami_ubuntu_2404" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "ami_windows_2025" {
  most_recent = true
  owners      = ["801119661308"]

  filter {
    name   = "name"
    values = ["Windows_Server-2025-English-Full-Base-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


###########################
### Free Instance Types ###
###########################

variable "instance_free" {
  type    = string
  default = "t3.small"
}


###################
### Access Keys ###
###################

variable "private_key_name" {
  type    = string
  default = "b2111933-pair"
}

variable "private_key_path" {
  type    = string
  default = "../keys/b2111933-pair.pem"
}


#########################
### Setup for Ansible ###
#########################

variable "setup_linux" {
  default = "../ansible/setup/linux.sh" # This script has Git & Docker
}

variable "setup_windows" {
  default = "../ansible/setup/windows.ps1"
}

#########################
### Ansible Playbooks ###
#########################

variable "pb_linux_path" {
  default = "../ansible/playbooks/linux"
}

variable "pb_windows_path" {
  default = "../ansible/playbooks/windows"
}
