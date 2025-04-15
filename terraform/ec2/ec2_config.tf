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
    # "${var.pb_linux_path}/docker/install.yaml",
    "${var.pb_linux_path}/git/install.yaml",
    "${var.pb_linux_path}/containers/install.yaml",
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
