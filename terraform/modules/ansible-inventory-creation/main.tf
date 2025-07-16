resource "local_file" "dynamic_inventory" {
  filename = "${path.module}/../../../ansible/inventory.ini"
  content  = <<EOT
[web]
${var.bastion_public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/Downloads/oleg-key.pem
EOT
}

resource "local_file" "private_inventory" {
  filename = "${path.module}/../../../offline-k8s/ansible/inventory.ini"

  content = <<EOT
[master]
master ansible_host=${element(var.private_ips, 0)} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/Downloads/oleg-key.pem

[workers]
%{ for idx, ip in slice(var.private_ips, 1, length(var.private_ips)) ~}
worker${idx + 1} ansible_host=${ip} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/Downloads/oleg-key.pem
%{ endfor ~}

[cluster:children]
master
workers
EOT
}