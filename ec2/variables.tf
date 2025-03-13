variable "security_group" {}

variable "subnet" {}

variable "key_name" {
  type    = string
  default = "b2111933-pair"
}

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
