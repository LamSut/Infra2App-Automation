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

variable "security_group" {}
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

variable "instance_free" {}


###################
### Access Keys ###
###################

variable "private_key_name" {}
variable "private_key_path" {}


#########################
### Setup for Ansible ###
#########################

variable "setup_linux" {}
variable "setup_windows" {}


#########################
### Ansible Playbooks ###
#########################

variable "pb_linux_path" {}
variable "pb_windows_path" {}
