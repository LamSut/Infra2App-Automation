###################################
### Infrastructure Provisioning ###
###################################

resource "aws_instance" "ec2_hack" {
  count = var.deploy_hack ? 1 : 0

  tags = { Name = "B2111933 Hack Website" }

  ami           = data.aws_ami.ami_amazon_2023.id
  instance_type = var.instance_free
  root_block_device {
    volume_size = 25
    volume_type = "gp3"
  }

  subnet_id              = var.public_subnet[0]
  vpc_security_group_ids = [var.security_group["sg_linux"]]
  key_name               = var.private_key_name

  provisioner "remote-exec" {
    script = var.setup_linux
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }
}

resource "aws_instance" "ec2_pizza" {
  count = var.deploy_pizza ? 1 : 0

  tags = { Name = "B2111933 Pizza Website" }

  ami           = data.aws_ami.ami_ubuntu_2404.id
  instance_type = var.instance_free
  root_block_device {
    volume_size = 25
    volume_type = "gp3"
  }

  subnet_id              = var.public_subnet[0]
  vpc_security_group_ids = [var.security_group["sg_linux"]]
  key_name               = var.private_key_name

  provisioner "remote-exec" {
    script = var.setup_linux
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }
}

resource "aws_eip" "eip_hack" {
  count = var.deploy_hack ? 1 : 0

  tags     = { Name = "B2111933 Hack Website EIP" }
  instance = aws_instance.ec2_hack[0].id

  depends_on = [aws_instance.ec2_hack]
}

resource "aws_eip" "eip_pizza" {
  count = var.deploy_pizza ? 1 : 0

  tags     = { Name = "B2111933 Pizza Website EIP" }
  instance = aws_instance.ec2_pizza[0].id

  depends_on = [aws_instance.ec2_pizza]
}

################################
### Configuration Management ###
################################

locals {
  hack_user  = "ec2-user"
  pizza_user = "ubuntu"

  hack_playbooks = [
    "${var.pb_linux_path}/hack-website/install.yaml",
  ]
  pizza_playbooks = [
    "${var.pb_linux_path}/pizza-website/install.yaml",
  ]
}

resource "null_resource" "hack_config" {
  count = var.deploy_hack ? 1 : 0

  triggers = {
    always_run = timestamp()
  }

  depends_on = [aws_instance.ec2_hack]

  provisioner "local-exec" {
    command = join(" && ", concat(
      ["echo \"Running Ansible playbooks on Hack instance with IP: ${aws_eip.eip_hack[0].public_ip}\""],
      [for pb in local.hack_playbooks : format(
        "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u %s --key-file %s -T 300 -i '%s,' %s",
        local.hack_user,
        var.private_key_path,
        aws_eip.eip_hack[0].public_ip,
        pb
      )]
    ))
  }
}

resource "null_resource" "pizza_config" {
  count = var.deploy_pizza ? 1 : 0

  triggers = {
    always_run = timestamp()
  }

  depends_on = [aws_instance.ec2_pizza]

  provisioner "local-exec" {
    command = join(" && ", concat(
      ["echo \"Running Ansible playbooks on Pizza instance with IP: ${aws_eip.eip_pizza[0].public_ip}\""],
      [for pb in local.pizza_playbooks : format(
        "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u %s --key-file %s -T 300 -i '%s,' %s",
        local.pizza_user,
        var.private_key_path,
        aws_eip.eip_pizza[0].public_ip,
        pb
      )]
    ))
  }
}

################################
### Access Check Validation  ###
################################

resource "null_resource" "hack_access_check_trigger" {
  count      = var.deploy_hack ? 1 : 0
  depends_on = [null_resource.hack_config]
  triggers = {
    always_run = timestamp()
  }
}

resource "null_resource" "pizza_access_check_trigger" {
  count      = var.deploy_pizza ? 1 : 0
  depends_on = [null_resource.pizza_config]
  triggers = {
    always_run = timestamp()
  }
}


data "http" "hack_access_check" {
  count      = var.deploy_hack ? 1 : 0
  depends_on = [null_resource.hack_access_check_trigger]

  url = "http://${aws_eip.eip_hack[0].public_ip}"

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Hack website instance (${aws_eip.eip_hack[0].public_ip}) did not return HTTP 200"
    }
  }
}

data "http" "pizza_access_check" {
  count      = var.deploy_pizza ? 1 : 0
  depends_on = [null_resource.pizza_access_check_trigger]

  url = "http://${aws_eip.eip_pizza[0].public_ip}"

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Pizza website instance (${aws_eip.eip_pizza[0].public_ip}) did not return HTTP 200"
    }
  }
}


resource "null_resource" "hack_access_check_log" {
  count = var.deploy_hack ? 1 : 0

  triggers = {
    ip     = data.http.hack_access_check[0].url
    status = tostring(data.http.hack_access_check[0].status_code)
  }

  provisioner "local-exec" {
    command = "echo 'Hack Website is accessible: ${data.http.hack_access_check[0].url} → ${data.http.hack_access_check[0].status_code}'"
  }

  depends_on = [data.http.hack_access_check]
}

resource "null_resource" "pizza_access_check_log" {
  count = var.deploy_pizza ? 1 : 0

  triggers = {
    ip     = data.http.pizza_access_check[0].url
    status = tostring(data.http.pizza_access_check[0].status_code)
  }

  provisioner "local-exec" {
    command = "echo 'Pizza Website is accessible: ${data.http.pizza_access_check[0].url} → ${data.http.pizza_access_check[0].status_code}'"
  }

  depends_on = [data.http.pizza_access_check]
}
