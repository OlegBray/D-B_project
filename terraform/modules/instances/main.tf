resource "aws_key_pair" "default" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

# Security Group for Public Instance
resource "aws_security_group" "public_sg" {
  name        = "oleg-public-sg"
  description = "Allow SSH from internet"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for Private Instances (only accessible from public SG)
resource "aws_security_group" "private_sg" {
  name        = "oleg-private-sg"
  description = "Allow SSH from public instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Public Instance (Bastion)
resource "aws_instance" "public" {
  count                       = var.public_instance_count
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = element(var.public_subnet_ids, count.index % length(var.public_subnet_ids))
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  key_name                    = var.key_name

  user_data = <<EOF
#!/bin/bash
mkdir -p /home/ubuntu/.ssh
cat << 'KEY' > /home/ubuntu/.ssh/id_rsa
${tls_private_key.bastion_key.private_key_pem}
KEY
chmod 600 /home/ubuntu/.ssh/id_rsa
chown ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa
EOF

  tags = {
    Name = "public-oleg-instance"
  }
}

# Private Instances
resource "aws_instance" "private" {
  count                       = var.private_instance_count
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = element(var.private_subnet_ids, count.index % length(var.private_subnet_ids))
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.private_sg.id]
  key_name                    = var.key_name

  tags = {
    Name = "private-oleg-instance-${count.index + 1}"
  }
}
