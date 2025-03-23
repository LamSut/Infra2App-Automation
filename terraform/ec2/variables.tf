# Keys
variable "private_key_name" {
  type    = string
  default = "b2111933-pair"
}

variable "private_key_path" {
  type    = string
  default = "../keys/b2111933-pair.pem"
}

# Networking
variable "security_group" {
  type = map(string)
  default = {
    "sg_linux"   = "sg_linux",
    "sg_windows" = "sg_windows"
  }
}

variable "public_subnet" {}

variable "private_subnet" {}

# Free AMIs
variable "ami_free_amazon" {
  type    = string
  default = "ami-08b5b3a93ed654d19"
}

variable "ami_free_ubuntu" {
  type    = string
  default = "ami-04b4f1a9cf54c11d0"
}

variable "ami_free_windows" {
  type    = string
  default = "ami-001adaa5c3ee02e10"
}

# Free Instance Types
variable "instance_type_free" {
  type    = string
  default = "t2.micro"
}

# Setup for Ansible
variable "setup_amazon" {
  default = "../ansible/setup/amazon.sh"
}

variable "setup_ubuntu" {
  default = "../ansible/setup/ubuntu.sh"
}

variable "setup_windows" {
  default = "../ansible/setup/windows.ps1"
}

# Ansible Playbooks
variable "pb_linux_path" {
  default = "../ansible/playbooks/linux"
}

variable "pb_windows_path" {
  default = "../ansible/playbooks/windows"
}
