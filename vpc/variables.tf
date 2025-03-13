variable "default_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnets" {
  type = list(object({
    cidr_block        = string
    availability_zone = string
  }))
  default = [
    {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"
    },
    {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1a"
    },
    {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "us-east-1a"
    },
    {
      cidr_block        = "10.0.4.0/24"
      availability_zone = "us-east-1a"
    }
  ]
}

variable "private_subnets" {
  type = list(object({
    cidr_block        = string
    availability_zone = string
  }))
  default = [
    {
      cidr_block        = "10.0.101.0/24"
      availability_zone = "us-east-1a"
    },
    {
      cidr_block        = "10.0.102.0/24"
      availability_zone = "us-east-1a"
    },
    {
      cidr_block        = "10.0.103.0/24"
      availability_zone = "us-east-1a"
    },
    {
      cidr_block        = "10.0.104.0/24"
      availability_zone = "us-east-1a"
    }
  ]
}
