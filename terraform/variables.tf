#####################
######## VPC ########
#####################


### Network Configuration ###

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


### Security Groups ###

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


#####################
######## EC2 ########
#####################


### EC2 Instances ###

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


### EC2 Networking ###

variable "security_group" {
  type = map(string)
  default = {
    "sg_linux"   = "sg_linux",
    "sg_windows" = "sg_windows"
  }
}

### Free AWS AMIs ###

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


### Free Instance Types ###

variable "instance_free" {
  type    = string
  default = "t3.small"
}


### Access Keys ###

variable "private_key_name" {
  type    = string
  default = "b2111933-pair"
}

variable "private_key_path" {
  type    = string
  default = "../keys/b2111933-pair.pem"
}



### Setup for Ansible ###

variable "setup_linux" {
  default = "../ansible/setup/linux.sh" # This script has Git & Docker
}

variable "setup_windows" {
  default = "../ansible/setup/windows.ps1"
}


### Ansible Playbooks ###

variable "pb_linux_path" {
  default = "../ansible/playbooks/linux"
}

variable "pb_windows_path" {
  default = "../ansible/playbooks/windows"
}
