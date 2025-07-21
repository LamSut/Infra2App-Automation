#################
### Variables ###
#################

variables {
  instance_free    = "t3.small"
  private_key_name = "b2111933-pair"
}


#############################
### Hack Website Instance ###
#############################

run "hack_tests" {
  command = plan

  assert {
    condition     = module.ec2.hack_instance_count == 0 || module.ec2.hack_key_name == var.private_key_name
    error_message = "Hack website must use the configured key pair if instance exists."
  }

  assert {
    condition     = module.ec2.hack_instance_count == 0 || startswith(module.ec2.hack_instance_ami, "ami-")
    error_message = "Hack website must use a valid AMI if instance exists."
  }

  assert {
    condition     = module.ec2.hack_instance_count == 0 || module.ec2.hack_instance_type == var.instance_free
    error_message = "Hack website must use the correct Free Tier instance type if instance exists."
  }

  assert {
    condition     = module.ec2.hack_instance_count == 0 || module.ec2.hack_volume_size >= 20
    error_message = "Hack instance root volume must be at least 20GB if instance exists."
  }

  assert {
    condition     = module.ec2.hack_instance_count == 0 || module.ec2.hack_volume_type == "gp3"
    error_message = "Hack instance root volume must be gp3 if instance exists."
  }
}

##############################
### Pizza Website Instance ###
##############################

run "pizza_tests" {
  command = plan

  assert {
    condition     = module.ec2.pizza_instance_count == 0 || module.ec2.pizza_key_name == var.private_key_name
    error_message = "Pizza website must use the configured key pair if instance exists."
  }

  assert {
    condition     = module.ec2.pizza_instance_count == 0 || startswith(module.ec2.pizza_instance_ami, "ami-")
    error_message = "Hack website must use a valid AMI if instance exists."
  }

  assert {
    condition     = module.ec2.pizza_instance_count == 0 || module.ec2.pizza_instance_type == var.instance_free
    error_message = "Pizza website must use the correct Free Tier instance type if instance exists."
  }

  assert {
    condition     = module.ec2.pizza_instance_count == 0 || module.ec2.pizza_volume_size >= 20
    error_message = "Pizza instance root volume must be at least 20GB if instance exists."
  }

  assert {
    condition     = module.ec2.pizza_instance_count == 0 || module.ec2.pizza_volume_type == "gp3"
    error_message = "Pizza instance root volume must be gp3 if instance exists."
  }
}

########################
### Amazon Instances ###
########################

run "amazon_tests" {
  command = plan

  assert {
    condition = module.ec2.amazon_instance_count == 0 || alltrue([
      for k in module.ec2.amazon_key_name : k == var.private_key_name
    ])
    error_message = "All Amazon Linux instances must use the configured key pair."
  }

  assert {
    condition = module.ec2.amazon_instance_count == 0 || alltrue([
      for t in module.ec2.amazon_instance_ami : t == data.aws_ami.ami_amazon_2023.id
    ])
    error_message = "All Amazon Linux instances must use the expected AMI."
  }

  assert {
    condition = module.ec2.amazon_instance_count == 0 || alltrue([
      for t in module.ec2.amazon_instance_type : t == var.instance_free
    ])
    error_message = "All Amazon Linux instances must use the correct Free Tier instance type."
  }

  assert {
    condition = module.ec2.amazon_instance_count == 0 || alltrue([
      for t in module.ec2.amazon_volume_size : t >= 15
    ])
    error_message = "Each Amazon Linux instance must have a root volume of at least 15GB."
  }

  assert {
    condition = module.ec2.amazon_instance_count == 0 || alltrue([
      for t in module.ec2.amazon_volume_type : t == "gp3"
    ])
    error_message = "All Amazon Linux instances must use gp3 volume type."
  }
}


########################
### Ubuntu Instances ###
########################

run "ubuntu_tests" {
  command = plan

  assert {
    condition = module.ec2.ubuntu_instance_count == 0 || alltrue([
      for k in module.ec2.ubuntu_key_name : k == var.private_key_name
    ])
    error_message = "All Ubuntu instances must use the configured key pair."
  }

  assert {
    condition = module.ec2.ubuntu_instance_count == 0 || alltrue([
      for t in module.ec2.ubuntu_instance_ami : t == data.aws_ami.ami_ubuntu_2404.id
    ])
    error_message = "All Ubuntu instances must use the expected AMI."
  }

  assert {
    condition = module.ec2.ubuntu_instance_count == 0 || alltrue([
      for t in module.ec2.ubuntu_instance_type : t == var.instance_free
    ])
    error_message = "All Ubuntu instances must use the correct Free Tier instance type."
  }

  assert {
    condition = module.ec2.ubuntu_instance_count == 0 || alltrue([
      for t in module.ec2.ubuntu_volume_size : t >= 15
    ])
    error_message = "Each Ubuntu instance must have a root volume of at least 15GB."
  }

  assert {
    condition = module.ec2.ubuntu_instance_count == 0 || alltrue([
      for t in module.ec2.ubuntu_volume_type : t == "gp3"
    ])
    error_message = "All Ubuntu instances must use gp3 volume type."
  }
}

########################
### Windows Instance ###
########################

run "windows_tests" {
  command = plan

  assert {
    condition = module.ec2.windows_instance_count == 0 || alltrue([
      for k in module.ec2.windows_key_name : k == var.private_key_name
    ])
    error_message = "All Windows instances must use the configured key pair."
  }

  assert {
    condition = module.ec2.windows_instance_count == 0 || alltrue([
      for t in module.ec2.windows_instance_ami : t == data.aws_ami.ami_windows_2025.id
    ])
    error_message = "All Windows instances must use the expected AMI."
  }

  assert {
    condition = module.ec2.windows_instance_count == 0 || alltrue([
      for t in module.ec2.windows_instance_type : t == var.instance_free
    ])
    error_message = "All Windows instances must use the correct Free Tier instance type."
  }

  assert {
    condition = module.ec2.windows_instance_count == 0 || alltrue([
      for t in module.ec2.windows_volume_size : t >= 30
    ])
    error_message = "Each Windows instance must have a root volume of at least 30GB."
  }

  assert {
    condition = module.ec2.windows_instance_count == 0 || alltrue([
      for t in module.ec2.windows_volume_type : t == "gp3"
    ])
    error_message = "All Windows instances must use gp3 volume type."
  }
}
