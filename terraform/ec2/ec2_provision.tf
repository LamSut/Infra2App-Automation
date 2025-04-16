#Provisioning

resource "aws_instance" "amazon" {
  count = 1
  tags  = { Name = "B2111933 Amazon Linux ${count.index + 1}" }

  ami                    = var.ami_free_amazon
  instance_type          = var.instance_type_free
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

resource "aws_instance" "ubuntu" {
  count = 0
  tags  = { Name = "B2111933 Ubuntu ${count.index + 1}" }

  ami                    = var.ami_free_ubuntu
  instance_type          = var.instance_type_free
  subnet_id              = var.public_subnet[1]
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

resource "aws_instance" "windows" {
  count = 0
  tags  = { Name = "B2111933 Windows ${count.index + 1}" }

  ami                    = var.ami_free_windows
  instance_type          = var.instance_type_free
  subnet_id              = var.public_subnet[0]
  vpc_security_group_ids = [var.security_group["sg_windows"]]

  key_name  = var.private_key_name
  user_data = file(var.setup_windows)
}
