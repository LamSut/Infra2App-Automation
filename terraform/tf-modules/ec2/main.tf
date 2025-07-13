###################################
### Infrastructure Provisioning ###
###################################

resource "aws_instance" "ec2_hack" {

  tags = { Name = "B2111933 Hack Website" }

  ami                    = data.aws_ami.ami_amazon_2023.id
  instance_type          = var.instance_free
  subnet_id              = var.public_subnet[0]
  vpc_security_group_ids = [var.security_group["sg_linux"]]

  key_name = var.private_key_name

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

resource "aws_eip" "eip_hack" {

  tags = { Name = "B2111933 Hack Website EIP" }

  instance   = aws_instance.ec2_hack.id
  depends_on = [aws_instance.ec2_hack]

}


resource "aws_instance" "ec2_pizza" {

  tags = { Name = "B2111933 Pizza Website" }

  ami                    = data.aws_ami.ami_ubuntu_2404.id
  instance_type          = var.instance_free
  subnet_id              = var.public_subnet[0]
  vpc_security_group_ids = [var.security_group["sg_linux"]]

  key_name = var.private_key_name

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

resource "aws_eip" "eip_pizza" {

  tags = { Name = "B2111933 Pizza Website EIP" }

  instance   = aws_instance.ec2_pizza.id
  depends_on = [aws_instance.ec2_pizza]

}


################################
### Configuration Management ###
################################

locals {

  hack_public_ip = aws_eip.eip_hack.public_ip
  hack_user      = "ec2-user"

  hack_playbooks = [
    "${var.pb_linux_path}/hack-website/install.yaml",
  ]

  pizza_public_ip = aws_eip.eip_pizza.public_ip
  pizza_user      = "ubuntu"

  pizza_playbooks = [
    "${var.pb_linux_path}/pizza-website/install.yaml",
  ]

}

resource "null_resource" "hack_config" {

  triggers = {
    always_run = timestamp()
  }

  depends_on = [
    aws_instance.ec2_hack,
  ]

  provisioner "local-exec" {
    command = join(" && ", concat(
      ["echo \"Running Ansible playbooks on Hack instance with IP: ${local.hack_public_ip}\""],
      [for pb in local.hack_playbooks : format(
        "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u %s --key-file %s -T 300 -i '%s,' %s",
        local.hack_user,
        var.private_key_path,
        local.hack_public_ip,
        pb
      )]
    ))
  }

}


resource "null_resource" "pizza_config" {

  triggers = {
    always_run = timestamp()
  }

  depends_on = [
    aws_instance.ec2_pizza,
  ]

  provisioner "local-exec" {
    command = join(" && ", concat(
      ["echo \"Running Ansible playbooks on Pizza instance with IP: ${local.pizza_public_ip}\""],
      [for pb in local.pizza_playbooks : format(
        "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u %s --key-file %s -T 300 -i '%s,' %s",
        local.pizza_user,
        var.private_key_path,
        local.pizza_public_ip,
        pb
      )]
    ))
  }

}

