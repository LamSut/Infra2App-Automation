# Network
variable "security_group" {
  type = map(string)
  default = {
    "sg_linux"   = "sg_linux",
    "sg_windows" = "sg_windows"
  }
}

variable "public_subnet" {}

variable "private_subnet" {}

# Free EC2 
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

variable "instance_type_free" {
  type    = string
  default = "t2.micro"
}

# Keys
variable "private_key_name" {
  type    = string
  default = "b2111933-pair"
}

variable "private_key_path" {
  type    = string
  default = "../keys/b2111933-pair.pem"
}

# Ansible Playbooks
variable "playbooks_linux" {
  type = list(string)
  default = [
    "../ansible/playbooks/nginx/linux-install.yaml"
  ]
}

variable "playbooks_windows" {
  type = list(string)
  default = [
    "../ansible/playbooks/nginx/windows-install.yaml"
  ]
}
