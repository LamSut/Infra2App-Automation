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

##################
### Networking ###
##################

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

variable "ami_free_amazon" {
  type    = string
  default = "ami-05ffe3c48a9991133"
}

variable "ami_free_ubuntu" {
  type    = string
  default = "ami-020cba7c55df1f615"
}

variable "ami_free_windows" {
  type    = string
  default = "ami-02b60b5095d1e5227"
}


###########################
### Free Instance Types ###
###########################

variable "instance_type_free" {
  type    = string
  default = "t3.small"
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
