resource "aws_instance" "amazon" {
  count = 1

  ami           = var.ami_free_amazon
  instance_type = var.instance_type_free

  key_name = var.private_key_name

  subnet_id              = var.public_subnet[0]
  vpc_security_group_ids = [var.security_group["sg_linux"]]

  provisioner "remote-exec" {
    inline = [
      "sudo dnf update -y",
      "sudo dnf install -y amazon-linux-extras",
      "sudo amazon-linux-extras enable ansible2",
      "sudo dnf install -y ansible"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ec2-user --key-file ${var.private_key_path} -T 300 -i '${self.public_ip},' playbooks/nginx.yaml"
  }

  tags = {
    Name = "B2111933 Amazon Linux"
  }
}

resource "aws_instance" "ubuntu" {
  count = 1

  ami           = var.ami_free_ubuntu
  instance_type = var.instance_type_free

  key_name = var.private_key_name

  subnet_id              = var.public_subnet[1]
  vpc_security_group_ids = [var.security_group["sg_linux"]]

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y software-properties-common",
      "sudo apt-add-repository --yes --update ppa:ansible/ansible",
      "sudo apt install -y ansible"
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --key-file ${var.private_key_path} -T 300 -i '${self.public_ip},' playbooks/nginx.yaml"
  }

  tags = {
    Name = "B2111933 Ubuntu"
  }
}

resource "aws_instance" "windows" {
  count = 1

  ami           = var.ami_free_windows
  instance_type = var.instance_type_free

  key_name = var.private_key_name

  subnet_id              = var.public_subnet[2]
  vpc_security_group_ids = [var.security_group["sg_windows"]]

  tags = {
    Name = "B2111933 Windows"
  }
}
