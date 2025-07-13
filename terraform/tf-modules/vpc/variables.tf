#############################
### Network Configuration ###
#############################

variable "default_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type = list(object({
    cidr_block        = string
    availability_zone = string
  }))
  default = [
    {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"
    },
    # {
    #   cidr_block        = "10.0.2.0/24"
    #   availability_zone = "us-east-1a"
    # },
  ]
}

# variable "private_subnets" {
#   type = list(object({
#     cidr_block        = string
#     availability_zone = string
#   }))
#   default = [
#     {
#       cidr_block        = "10.0.101.0/24"
#       availability_zone = "us-east-1a"
#     },
#     {
#       cidr_block        = "10.0.102.0/24"
#       availability_zone = "us-east-1a"
#     },
#   ]
# }



#######################
### Security Groups ###
#######################

variable "security_groups_config" {
  type = map(object({
    description = string
    ingress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    egress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  }))
  default = {
    sg_linux = {
      description = "Security Group for Linux"
      ingress = [
        {
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          from_port   = 3000
          to_port     = 3000
          protocol    = "tcp"
          cidr_blocks = ["115.78.6.138/32"] # Admin VPN IP
        },
        # {
        #   from_port   = 5173
        #   to_port     = 5173
        #   protocol    = "tcp"
        #   cidr_blocks = ["0.0.0.0/0"]
        # },
        {
          from_port   = -1
          to_port     = -1
          protocol    = "icmp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
      egress = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    },
    sg_windows = {
      description = "Security Group for Windows"
      ingress = [
        {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          from_port   = 3389
          to_port     = 3389
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        # {
        #   from_port   = 5173
        #   to_port     = 5173
        #   protocol    = "tcp"
        #   cidr_blocks = ["0.0.0.0/0"]
        # },
        {
          from_port   = 5986
          to_port     = 5986
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          from_port   = -1
          to_port     = -1
          protocol    = "icmp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
      egress = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
  }
}
