#####################
### EC2 Instances ###
#####################

variable "provision_hack" {
  description = "Provision EC2 for Hack Website or not"
  type        = bool
  default     = true
}

variable "provision_pizza" {
  description = "Provision EC2 for Pizza Website or not"
  type        = bool
  default     = true
}

variable "provision_amazon" {
  description = "Number of Amazon Linux EC2 instances to provision"
  type        = number
  default     = 1
}

variable "provision_ubuntu" {
  description = "Number of Ubuntu EC2 instances to provision"
  type        = number
  default     = 1
}

variable "provision_windows" {
  description = "Number of Windows EC2 instances to provision"
  type        = number
  default     = 1
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
