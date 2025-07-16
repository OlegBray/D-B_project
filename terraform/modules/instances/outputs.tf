output "bastion_id" {
  value = aws_instance.public[0].id
}

output "bastion_public_ip" {
  value = aws_instance.public[0].public_ip
}

output "public_instance_ids" {
  value = aws_instance.public[*].id
}

output "private_instance_ids" {
  value = aws_instance.private[*].id
}

output "private_instance_private_ips" {
  value = aws_instance.private[*].private_ip
}
