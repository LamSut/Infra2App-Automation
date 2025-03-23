#Provisioning
resource "aws_instance" "amazon" {
  count    = 1
  key_name = var.private_key_name

  ami                    = var.ami_free_amazon
  instance_type          = var.instance_type_free
  subnet_id              = var.public_subnet[0]
  vpc_security_group_ids = [var.security_group["sg_linux"]]

  provisioner "remote-exec" {
    inline = [
      "sudo dnf update -y",
      "sudo dnf install -y python3 python3-pip",
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

  tags = {
    Name = "B2111933 Amazon Linux"
  }
}

resource "aws_instance" "ubuntu" {
  count    = 2
  key_name = var.private_key_name

  ami                    = var.ami_free_ubuntu
  instance_type          = var.instance_type_free
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

  tags = {
    Name = "B2111933 Ubuntu"
  }
}

resource "aws_instance" "windows" {
  count    = 2
  key_name = var.private_key_name

  ami                    = var.ami_free_windows
  instance_type          = var.instance_type_free
  subnet_id              = var.public_subnet[0]
  vpc_security_group_ids = [var.security_group["sg_windows"]]

  user_data = <<EOF
  <powershell>
  New-NetFirewallRule -DisplayName "WinRM HTTPS" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5986
  New-NetFirewallRule -DisplayName "Allow HTTP" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 80
  New-NetFirewallRule -DisplayName "Allow HTTPS" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 443
  winrm quickconfig -q
  winrm set winrm/config/service '@{AllowUnencrypted="true"}'
  winrm set winrm/config/service/auth '@{Basic="true"}'
  winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="1024"}'
  $cert = New-SelfSignedCertificate -DnsName (hostname) -CertStoreLocation Cert:\LocalMachine\My
  winrm create winrm/config/Listener?Address=*+Transport=HTTPS "@{Hostname=`"$(hostname)`"; CertificateThumbprint=`"$($cert.Thumbprint)`"}"
  net localgroup "Remote Management Users" Administrator /add
  Restart-Service winrm
  </powershell>
  EOF

  tags = {
    Name = "B2111933 Windows"
  }
}

# Configuration Management
locals {
  # Linux
  linux_public_ips = concat(
    aws_instance.amazon[*].public_ip,
    aws_instance.ubuntu[*].public_ip
  )
  linux_users = concat(
    [for i in aws_instance.amazon : "ec2-user"],
    [for i in aws_instance.ubuntu : "ubuntu"]
  )
  linux_playbooks = [
    "${var.pb_linux_path}/nginx/install.yaml"
  ]

  # Windows
  windows_public_ips = aws_instance.windows[*].public_ip
  windows_users      = [for i in aws_instance.windows : "Administrator"]
  windows_playbooks = [
    "${var.pb_windows_path}/nginx/install.yaml"
  ]
}

resource "null_resource" "linux_config" {
  count = length(local.linux_public_ips)
  depends_on = [
    aws_instance.amazon,
    aws_instance.ubuntu
  ]

  provisioner "local-exec" {
    command = join(" && ", concat(
      ["echo \"Running Ansible playbooks on Linux instance with IP: ${local.linux_public_ips[count.index]}\""],
      [for pb in local.linux_playbooks : format(
        "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u %s --key-file %s -T 300 -i '%s,' %s",
        local.linux_users[count.index],
        var.private_key_path,
        local.linux_public_ips[count.index],
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
