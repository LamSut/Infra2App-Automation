# Configuration Management
locals {
  # Hack Website
  hack_public_ip = aws_instance.hack.public_ip
  hack_user      = "ec2-user"

  # Hack Website Playbooks
  hack_playbooks = [
    "${var.pb_linux_path}/hack-website/install.yaml",
  ]

  # Pizza Website
  pizza_public_ip = aws_instance.pizza.public_ip
  pizza_user      = "ubuntu"

  # Pizza Website Playbooks
  pizza_playbooks = [
    "${var.pb_linux_path}/pizza-website/install.yaml",
  ]
}

# Hack Website Configuration Management
resource "null_resource" "hack_config" {
  # For app updates
  triggers = {
    always_run = timestamp()
  }

  depends_on = [
    aws_instance.hack,
  ]

  provisioner "local-exec" {
    command = join(" && ", concat(
      ["echo \"Running Ansible playbooks on Hack instance with IP: ${local.hack_public_ip}\""],
      [for pb in local.hack_playbooks : format(
        "ANSIBLE_HOST_KEY_CHECKING=False python3 -m ansible playbook -u %s --key-file %s -T 300 -i '%s,' %s",
        local.hack_user,
        var.private_key_path,
        local.hack_public_ip,
        pb
      )]
    ))
  }
}

# Pizza Website Configuration Management
resource "null_resource" "pizza_config" {
  # For app updates
  triggers = {
    always_run = timestamp()
  }

  depends_on = [
    aws_instance.pizza,
  ]

  provisioner "local-exec" {
    command = join(" && ", concat(
      ["echo \"Running Ansible playbooks on Pizza instance with IP: ${local.pizza_public_ip}\""],
      [for pb in local.pizza_playbooks : format(
        "ANSIBLE_HOST_KEY_CHECKING=False python3 -m ansible playbook -u %s --key-file %s -T 300 -i '%s,' %s",
        local.pizza_user,
        var.private_key_path,
        local.pizza_public_ip,
        pb
      )]
    ))
  }
}
