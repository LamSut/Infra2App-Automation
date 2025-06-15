# Infrastructure Provisioning
resource "aws_instance" "amazon" {
  count = 0
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

# Configuration Management
locals {
  # Linux
  amazon_public_ips = concat(aws_instance.amazon[*].public_ip)
  ubuntu_public_ips = concat(aws_instance.ubuntu[*].public_ip)
  amazon_users      = concat([for i in aws_instance.amazon : "ec2-user"])
  ubuntu_users      = concat([for i in aws_instance.ubuntu : "ubuntu"])

  # Windows
  windows_public_ips = aws_instance.windows[*].public_ip
  windows_users      = [for i in aws_instance.windows : "Administrator"]

  # Ansible Playbooks
  amazon_playbooks = [
    "${var.pb_linux_path}/nginx/install.yaml",
  ]
  ubuntu_playbooks = [
    "${var.pb_linux_path}/nginx/install.yaml",
  ]
  windows_playbooks = [
    "${var.pb_windows_path}/nginx/install.yaml"
  ]
}

resource "null_resource" "amazon_config" {
  count = length(local.amazon_public_ips)

  depends_on = [
    aws_instance.amazon,
  ]

  provisioner "local-exec" {
    command = join(" && ", concat(
      ["echo \"Running Ansible playbooks on Amazon instance with IP: ${local.amazon_public_ips[count.index]}\""],
      [for pb in local.amazon_playbooks : format(
        "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u %s --key-file %s -T 300 -i '%s,' %s",
        local.amazon_users[count.index],
        var.private_key_path,
        local.amazon_public_ips[count.index],
        pb
      )]
    ))
  }
}

resource "null_resource" "ubuntu_config" {
  count = length(local.ubuntu_public_ips)
  depends_on = [
    aws_instance.ubuntu,
  ]

  provisioner "local-exec" {
    command = join(" && ", concat(
      ["echo \"Running Ansible playbooks on Ubuntu instance with IP: ${local.ubuntu_public_ips[count.index]}\""],
      [for pb in local.ubuntu_playbooks : format(
        "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u %s --key-file %s -T 300 -i '%s,' %s",
        local.ubuntu_users[count.index],
        var.private_key_path,
        local.ubuntu_public_ips[count.index],
        pb
      )]
    ))
  }
}

resource "null_resource" "windows_config" {
  count      = length(local.windows_public_ips)
  depends_on = [aws_instance.windows]

  provisioner "local-exec" {
    command = <<EOT
      echo "Waiting for Windows startup (60s)..."
      sleep 60
      while ! nc -z ${local.windows_public_ips[count.index]} 5986; do
        echo "Waiting for Windows to be ready..."
        sleep 10
      done
      echo "Windows is ready!"

      echo "Retrieving Windows password..."
      aws ec2 get-password-data --instance-id ${aws_instance.windows[count.index].id} --priv-launch-key ${var.private_key_path} --output text | tr -d '\r\n' > ../keys/${aws_instance.windows[count.index].id}.txt

      echo "Running Ansible playbooks on IP: ${local.windows_public_ips[count.index]}"
      for pb in ${join(" ", local.windows_playbooks)}; do
        ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook \
          -u ${local.windows_users[count.index]} --connection=winrm \
          --extra-vars "ansible_winrm_server_cert_validation=ignore ansible_winrm_password=$(awk '{print $2}' ../keys/${aws_instance.windows[count.index].id}.txt | tr -d '\r')" \
          -T 600 -i '${local.windows_public_ips[count.index]},' "$pb"
      done
    EOT
  }
}

