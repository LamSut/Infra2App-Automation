#############################
### Hack Website Instance ###
#############################

output "hack_instance_count" {
  description = "Number of Hack website instances"
  value       = length(aws_instance.ec2_hack)
}

output "hack_instance_id" {
  description = "Hack website instance ID"
  value       = length(aws_instance.ec2_hack) > 0 ? aws_instance.ec2_hack[0].id : ""
}

output "hack_public_ip" {
  description = "Public IP address of Hack website instance"
  value       = length(aws_eip.eip_hack) > 0 ? aws_eip.eip_hack[0].public_ip : ""
}

output "hack_admin_url" {
  description = "Full URL to the Hack Admin API docs"
  value       = length(aws_eip.eip_hack) > 0 ? format("http://%s:3000", aws_eip.eip_hack[0].public_ip) : ""
}

output "hack_private_ip" {
  description = "Private IP address of Hack website instance"
  value       = length(aws_instance.ec2_hack) > 0 ? aws_instance.ec2_hack[0].private_ip : ""
}

output "hack_public_dns" {
  description = "Public DNS of Hack website instance"
  value       = length(aws_instance.ec2_hack) > 0 ? aws_instance.ec2_hack[0].public_dns : ""
}

output "hack_private_dns" {
  description = "Private DNS of Hack website instance"
  value       = length(aws_instance.ec2_hack) > 0 ? aws_instance.ec2_hack[0].private_dns : ""
}

output "hack_instance_ami" {
  description = "AMI used by Hack website instance"
  value       = length(aws_instance.ec2_hack) > 0 ? aws_instance.ec2_hack[0].ami : ""
}

output "hack_instance_type" {
  description = "Instance type for Hack website instance"
  value       = length(aws_instance.ec2_hack) > 0 ? aws_instance.ec2_hack[0].instance_type : ""
}

output "hack_key_name" {
  description = "Key pair name used by Hack website instance"
  value       = length(aws_instance.ec2_hack) > 0 ? aws_instance.ec2_hack[0].key_name : ""
}

output "hack_subnet_id" {
  description = "Subnet ID where the Hack website instance is deployed"
  value       = length(aws_instance.ec2_hack) > 0 ? aws_instance.ec2_hack[0].subnet_id : ""
}

output "hack_security_group_ids" {
  description = "Security Group IDs attached to Hack website instance"
  value       = length(aws_instance.ec2_hack) > 0 ? aws_instance.ec2_hack[0].vpc_security_group_ids : []
}

##############################
### Pizza Website Instance ###
##############################

output "pizza_instance_count" {
  description = "Number of Pizza website instances"
  value       = length(aws_instance.ec2_pizza)
}

output "pizza_instance_id" {
  description = "Pizza website instance ID"
  value       = length(aws_instance.ec2_pizza) > 0 ? aws_instance.ec2_pizza[0].id : ""
}

output "pizza_public_ip" {
  description = "Public IP address of Pizza website instance"
  value       = length(aws_eip.eip_pizza) > 0 ? aws_eip.eip_pizza[0].public_ip : ""
}

output "pizza_admin_url" {
  description = "Full URL to the Pizza Admin API docs"
  value       = length(aws_eip.eip_pizza) > 0 ? format("http://%s:3000/api-docs/", aws_eip.eip_pizza[0].public_ip) : ""
}

output "pizza_private_ip" {
  description = "Private IP address of Pizza website instance"
  value       = length(aws_instance.ec2_pizza) > 0 ? aws_instance.ec2_pizza[0].private_ip : ""
}

output "pizza_public_dns" {
  description = "Public DNS of Pizza website instance"
  value       = length(aws_instance.ec2_pizza) > 0 ? aws_instance.ec2_pizza[0].public_dns : ""
}

output "pizza_private_dns" {
  description = "Private DNS of Pizza website instance"
  value       = length(aws_instance.ec2_pizza) > 0 ? aws_instance.ec2_pizza[0].private_dns : ""
}

output "pizza_instance_ami" {
  description = "AMI used by Pizza website instance"
  value       = length(aws_instance.ec2_pizza) > 0 ? aws_instance.ec2_pizza[0].ami : ""
}

output "pizza_instance_type" {
  description = "Instance type for Pizza website instance"
  value       = length(aws_instance.ec2_pizza) > 0 ? aws_instance.ec2_pizza[0].instance_type : ""
}

output "pizza_key_name" {
  description = "Key pair name used by Pizza website instance"
  value       = length(aws_instance.ec2_pizza) > 0 ? aws_instance.ec2_pizza[0].key_name : ""
}

output "pizza_subnet_id" {
  description = "Subnet ID where the Pizza website instance is deployed"
  value       = length(aws_instance.ec2_pizza) > 0 ? aws_instance.ec2_pizza[0].subnet_id : ""
}

output "pizza_security_group_ids" {
  description = "Security Group IDs attached to Pizza website instance"
  value       = length(aws_instance.ec2_pizza) > 0 ? aws_instance.ec2_pizza[0].vpc_security_group_ids : []
}


##############################
### Amazon Linux Instances ###
##############################

output "amazon_instance_count" {
  description = "Number of Amazon Linux instances"
  value       = length(aws_instance.amazon)
}

output "amazon_instance_ids" {
  description = "Amazon Linux instance IDs"
  value       = aws_instance.amazon[*].id
}

output "amazon_public_ips" {
  description = "Public IP addresses of Amazon Linux instances"
  value       = aws_instance.amazon[*].public_ip
}

output "amazon_private_ips" {
  description = "Private IP addresses of Amazon Linux instances"
  value       = aws_instance.amazon[*].private_ip
}

output "amazon_public_dns" {
  description = "Public DNS names of Amazon Linux instances"
  value       = aws_instance.amazon[*].public_dns
}

output "amazon_private_dns" {
  description = "Private DNS names of Amazon Linux instances"
  value       = aws_instance.amazon[*].private_dns
}

output "amazon_instance_ami" {
  description = "AMI used by Amazon Linux instance"
  value       = aws_instance.amazon[*].ami
}

output "amazon_instance_type" {
  description = "Instance type for Amazon Linux instance"
  value       = aws_instance.amazon[*].instance_type
}

output "amazon_key_name" {
  description = "Key pair name used by Amazon Linux instance"
  value       = aws_instance.amazon[*].key_name
}

output "amazon_subnet_id" {
  description = "Subnet ID where the Amazon Linux instance is deployed"
  value       = aws_instance.amazon[*].subnet_id
}

output "amazon_security_group_ids" {
  description = "Security Group IDs attached to Amazon Linux instance"
  value       = aws_instance.amazon[*].vpc_security_group_ids
}


########################
### Ubuntu Instances ###
########################

output "ubuntu_instance_count" {
  description = "Number of Ubuntu instances"
  value       = length(aws_instance.ubuntu)
}

output "ubuntu_instance_ids" {
  description = "Ubuntu instance IDs"
  value       = aws_instance.ubuntu[*].id
}

output "ubuntu_public_ips" {
  description = "Public IP addresses of Ubuntu instances"
  value       = aws_instance.ubuntu[*].public_ip
}

output "ubuntu_private_ips" {
  description = "Private IP addresses of Ubuntu instances"
  value       = aws_instance.ubuntu[*].private_ip
}

output "ubuntu_public_dns" {
  description = "Public DNS names of Ubuntu instances"
  value       = aws_instance.ubuntu[*].public_dns
}

output "ubuntu_private_dns" {
  description = "Private DNS names of Ubuntu instances"
  value       = aws_instance.ubuntu[*].private_dns
}

output "ubuntu_instance_ami" {
  description = "AMI used by Ubuntu instance"
  value       = aws_instance.ubuntu[*].ami
}

output "ubuntu_instance_type" {
  description = "Instance type for Ubuntu instance"
  value       = aws_instance.ubuntu[*].instance_type
}

output "ubuntu_key_name" {
  description = "Key pair name used by Ubuntu instance"
  value       = aws_instance.ubuntu[*].key_name
}

output "ubuntu_subnet_id" {
  description = "Subnet ID where the Ubuntu instance is deployed"
  value       = aws_instance.ubuntu[*].subnet_id
}

output "ubuntu_security_group_ids" {
  description = "Security Group IDs attached to Ubuntu instance"
  value       = aws_instance.ubuntu[*].vpc_security_group_ids
}


########################
### Windows Instance ###
########################

output "windows_instance_count" {
  description = "Number of Windows instances"
  value       = length(aws_instance.windows)
}

output "windows_instance_ids" {
  description = "Windows instance IDs"
  value       = aws_instance.windows[*].id
}
output "windows_public_ips" {
  description = "Public IP addresses of Windows instances"
  value       = aws_instance.windows[*].public_ip
}
output "windows_private_ips" {
  description = "Private IP addresses of Windows instances"
  value       = aws_instance.windows[*].private_ip
}
output "windows_public_dns" {
  description = "Public DNS names of Windows instances"
  value       = aws_instance.windows[*].public_dns
}
output "windows_private_dns" {
  description = "Private DNS names of Windows instances"
  value       = aws_instance.windows[*].private_dns
}
output "windows_instance_ami" {
  description = "AMI used by Windows instance"
  value       = aws_instance.windows[*].ami
}
output "windows_instance_type" {
  description = "Instance type for Windows instance"
  value       = aws_instance.windows[*].instance_type
}
output "windows_key_name" {
  description = "Key pair name used by Windows instance"
  value       = aws_instance.windows[*].key_name
}
output "windows_subnet_id" {
  description = "Subnet ID where the Windows instance is deployed"
  value       = aws_instance.windows[*].subnet_id
}
output "windows_security_group_ids" {
  description = "Security Group IDs attached to Windows instance"
  value       = aws_instance.windows[*].vpc_security_group_ids
}
