######################
### Cloud Provider ###
######################

provider "aws" {
  region = "us-east-1"
}


#####################
### EC2 Instances ###
#####################

variable "provision_hack" {
  description = "Provision EC2 for Hack Website or not"
  type        = bool
  default     = false
}

variable "provision_pizza" {
  description = "Provision EC2 for Pizza Website or not"
  type        = bool
  default     = false
}

variable "provision_amazon" {
  description = "Number of Amazon Linux EC2 instances to provision"
  type        = number
  default     = 0
}

variable "provision_ubuntu" {
  description = "Number of Ubuntu EC2 instances to provision"
  type        = number
  default     = 0
}

variable "provision_windows" {
  description = "Number of Windows EC2 instances to provision"
  type        = number
  default     = 0
}


#####################
### Free AWS AMIs ###
#####################

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
