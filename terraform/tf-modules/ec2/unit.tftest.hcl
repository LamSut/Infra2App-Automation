#############################
### Hack Website Instance ###
#############################

run "hack_tests" {
  command = plan

  assert {
    condition     = module.ec2.hack_instance_count == 0 || module.ec2.hack_key_name != ""
    error_message = "Hack website must have a key pair if instance exists"
  }

  assert {
    condition     = module.ec2.hack_instance_count == 0 || module.ec2.hack_instance_type != ""
    error_message = "Hack website must have an instance type if instance exists"
  }

  assert {
    condition     = module.ec2.hack_instance_count == 0 || module.ec2.hack_instance_ami != ""
    error_message = "Hack website must use a valid AMI if instance exists"
  }

  assert {
    condition     = module.ec2.hack_instance_count == 0 || module.ec2.hack_volume_size >= 20
    error_message = "Hack instance root volume must be at least 20GB."
  }

  assert {
    condition     = module.ec2.hack_instance_count == 0 || module.ec2.hack_volume_type == "gp3"
    error_message = "Hack instance root volume must be gp3."
  }
}

##############################
### Pizza Website Instance ###
##############################

run "pizza_tests" {
  command = plan

  assert {
    condition     = module.ec2.pizza_instance_count == 0 || module.ec2.pizza_key_name != ""
    error_message = "Pizza website must have a key pair if instance exists"
  }

  assert {
    condition     = module.ec2.pizza_instance_count == 0 || module.ec2.pizza_instance_type != ""
    error_message = "Pizza website must have an instance type if instance exists"
  }

  assert {
    condition     = module.ec2.pizza_instance_count == 0 || module.ec2.pizza_instance_ami != ""
    error_message = "Pizza website must use a valid AMI if instance exists"
  }

  assert {
    condition     = module.ec2.pizza_instance_count == 0 || module.ec2.pizza_volume_size >= 20
    error_message = "Pizza instance root volume must be at least 20GB."
  }

  assert {
    condition     = module.ec2.pizza_instance_count == 0 || module.ec2.pizza_volume_type == "gp3"
    error_message = "Pizza instance root volume must be gp3."
  }
}

########################
### Amazon Instances ###
########################

run "amazon_tests" {
  command = plan

  assert {
    condition     = module.ec2.amazon_instance_count == 0 || length(module.ec2.amazon_key_name) == module.ec2.amazon_instance_count
    error_message = "Each Amazon Linux instance must have a key pair"
  }

  assert {
    condition     = module.ec2.amazon_instance_count == 0 || length(module.ec2.amazon_instance_type) == module.ec2.amazon_instance_count
    error_message = "Each Amazon Linux instance must have a type"
  }

  assert {
    condition     = module.ec2.amazon_instance_count == 0 || length(module.ec2.amazon_instance_ami) == module.ec2.amazon_instance_count
    error_message = "Each Amazon Linux instance must have an AMI"
  }

  assert {
    condition     = module.ec2.amazon_instance_count == 0 || module.ec2.amazon_volume_size >= 15
    error_message = "Amazon Linux instance root volume must be at least 15GB."
  }

  assert {
    condition     = module.ec2.amazon_instance_count == 0 || module.ec2.amazon_volume_type == "gp3"
    error_message = "Amazon Linux instance root volume must be gp3."
  }
}

########################
### Ubuntu Instances ###
########################

run "ubuntu_tests" {
  command = plan

  assert {
    condition     = module.ec2.ubuntu_instance_count == 0 || length(module.ec2.ubuntu_key_name) == module.ec2.ubuntu_instance_count
    error_message = "Each Ubuntu instance must have a key pair"
  }

  assert {
    condition     = module.ec2.ubuntu_instance_count == 0 || length(module.ec2.ubuntu_instance_type) == module.ec2.ubuntu_instance_count
    error_message = "Each Ubuntu instance must have a type"
  }

  assert {
    condition     = module.ec2.ubuntu_instance_count == 0 || length(module.ec2.ubuntu_instance_ami) == module.ec2.ubuntu_instance_count
    error_message = "Each Ubuntu instance must have an AMI"
  }

  assert {
    condition     = module.ec2.ubuntu_instance_count == 0 || module.ec2.ubuntu_volume_size >= 15
    error_message = "Ubuntu instance root volume must be at least 15GB."
  }

  assert {
    condition     = module.ec2.ubuntu_instance_count == 0 || module.ec2.ubuntu_volume_type == "gp3"
    error_message = "Ubuntu instance root volume must be gp3."
  }
}

########################
### Windows Instance ###
########################

run "windows_tests" {
  command = plan

  assert {
    condition     = module.ec2.windows_instance_count == 0 || length(module.ec2.windows_key_name) == module.ec2.windows_instance_count
    error_message = "Each Windows instance must have a key pair"
  }

  assert {
    condition     = module.ec2.windows_instance_count == 0 || length(module.ec2.windows_instance_type) == module.ec2.windows_instance_count
    error_message = "Each Windows instance must have a type"
  }

  assert {
    condition     = module.ec2.windows_instance_count == 0 || length(module.ec2.windows_instance_ami) == module.ec2.windows_instance_count
    error_message = "Each Windows instance must have an AMI"
  }

  assert {
    condition     = module.ec2.windows_instance_count == 0 || module.ec2.windows_volume_size >= 30
    error_message = "Windows instance root volume must be at least 30GB."
  }

  assert {
    condition     = module.ec2.windows_instance_count == 0 || module.ec2.windows_volume_type == "gp3"
    error_message = "Windows instance root volume must be gp3."
  }
}
