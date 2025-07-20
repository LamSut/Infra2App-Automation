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
}
