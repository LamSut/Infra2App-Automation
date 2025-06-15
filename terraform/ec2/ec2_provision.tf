# Infrastructure Provisioning

# Hack Website with Amazon Linux
resource "aws_instance" "hack" {
  tags = { Name = "B2111933 Hack Website" }

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

# Pizza Website with Ubuntu
resource "aws_instance" "pizza" {
  tags = { Name = "B2111933 Pizza Website" }

  ami                    = var.ami_free_ubuntu
  instance_type          = var.instance_type_free
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
