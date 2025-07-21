#####################
### EC2 Instances ###
#####################

variable "provision_hack" {}
variable "provision_pizza" {}
variable "provision_amazon" {}
variable "provision_ubuntu" {}
variable "provision_windows" {}


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

variable "ami_amazon" {}
variable "ami_ubuntu" {}
variable "ami_windows" {}


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
