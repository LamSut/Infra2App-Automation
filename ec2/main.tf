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

  provisioner "local-exec" {
    command = join(" && ", [
      for pb in var.playbooks_linux :
      "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ${self.tags["Name"] == "B2111933 Ubuntu" ? "ubuntu" : "ec2-user"} --key-file ${var.private_key_path} -T 300 -i '${self.public_ip},' ${pb}"
    ])
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
    command = join(" && ", [
      for pb in var.playbooks_linux :
      "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ${self.tags["Name"] == "B2111933 Ubuntu" ? "ubuntu" : "ec2-user"} --key-file ${var.private_key_path} -T 300 -i '${self.public_ip},' ${pb}"
    ])
  }

  tags = {
    Name = "B2111933 Ubuntu"
  }
}

resource "aws_instance" "windows" {
  count = 1

  ami           = var.ami_free_windows
  instance_type = var.instance_type_free
  key_name      = var.private_key_name

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

resource "null_resource" "wait_for_windows" {
  count      = length(aws_instance.windows)
  depends_on = [aws_instance.windows]

  provisioner "local-exec" {
    command = <<EOT
      echo "Waiting for Windows startup (60s)..."
      sleep 60
      while ! nc -z ${aws_instance.windows[count.index].public_ip} 5986; do
        echo "Waiting for Windows to be ready..."
        sleep 10
      done
      echo "Windows is ready!"
    EOT
  }
}

resource "null_resource" "get_windows_password" {
  count      = length(aws_instance.windows)
  depends_on = [null_resource.wait_for_windows]

  provisioner "local-exec" {
    command = "aws ec2 get-password-data --instance-id ${aws_instance.windows[count.index].id} --priv-launch-key ${var.private_key_path} --output text | tr -d '\r\n' > ./keys/${aws_instance.windows[count.index].id}.txt"
  }
}

resource "null_resource" "ansible_windows" {
  count      = length(aws_instance.windows)
  depends_on = [null_resource.get_windows_password]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
    echo "Running Ansible with password: $(awk '{print $2}' ./keys/${aws_instance.windows[count.index].id}.txt | tr -d '\r')"
    for pb in ${join(" ", var.playbooks_windows)}; do
      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook \
        -u Administrator --connection=winrm \
        --extra-vars "ansible_winrm_server_cert_validation=ignore ansible_winrm_password=$(awk '{print $2}' ./keys/${aws_instance.windows[count.index].id}.txt | tr -d '\r')" \
        -T 600 -i '${aws_instance.windows[count.index].public_ip},' "$pb"
    done
  EOT
  }
}
