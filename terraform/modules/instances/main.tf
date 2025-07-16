data "aws_key_pair" "default" {
  key_name = var.key_name
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

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 8080
    to_port     = 8080
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

# Security Group for Private Instances
resource "aws_security_group" "private_sg" {
  name        = "oleg-private-sg"
  description = "Allow SSH and K8s API from public instance"
  vpc_id      = var.vpc_id

  # Allow SSH from bastion
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
    description     = "Allow SSH connection from bastion"
  }

  ingress {
    from_port       = 6443
    to_port         = 6443
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
    description     = "Allow k8s cluster access from bastion"
  }

  # General egress rule: allow traffic only inside VPC
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }
}

# Private-to-private ingress rules (moved out to avoid self-reference)
resource "aws_security_group_rule" "private_to_private_9345" {
  type                     = "ingress"
  from_port                = 9345
  to_port                  = 9345
  protocol                 = "tcp"
  security_group_id        = aws_security_group.private_sg.id
  source_security_group_id = aws_security_group.private_sg.id
  description              = "Allow k8s 9345 traffic inside private subnet"
}

resource "aws_security_group_rule" "private_to_private_6443" {
  type                     = "ingress"
  from_port                = 6443
  to_port                  = 6443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.private_sg.id
  source_security_group_id = aws_security_group.private_sg.id
  description              = "Allow k8s 6443 traffic inside private subnet"
}

resource "aws_security_group_rule" "private_to_private_10250" {
  type                     = "ingress"
  from_port                = 10250
  to_port                  = 10250
  protocol                 = "tcp"
  security_group_id        = aws_security_group.private_sg.id
  source_security_group_id = aws_security_group.private_sg.id
  description              = "Allow k8s 10250 traffic inside private subnet"
}

# Private-to-private egress rules
resource "aws_security_group_rule" "private_egress_9345" {
  type                     = "egress"
  from_port                = 9345
  to_port                  = 9345
  protocol                 = "tcp"
  security_group_id        = aws_security_group.private_sg.id
  source_security_group_id = aws_security_group.private_sg.id
  description              = "Egress: Allow k8s 9345 inside private subnet"
}

resource "aws_security_group_rule" "private_egress_6443" {
  type                     = "egress"
  from_port                = 6443
  to_port                  = 6443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.private_sg.id
  source_security_group_id = aws_security_group.private_sg.id
  description              = "Egress: Allow k8s 6443 inside private subnet"
}

resource "aws_security_group_rule" "private_egress_10250" {
  type                     = "egress"
  from_port                = 10250
  to_port                  = 10250
  protocol                 = "tcp"
  security_group_id        = aws_security_group.private_sg.id
  source_security_group_id = aws_security_group.private_sg.id
  description              = "Egress: Allow k8s 10250 inside private subnet"
}

# Public Instance (Bastion)
resource "aws_instance" "public" {
  count                       = var.public_instance_count
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = element(var.public_subnet_ids, count.index % length(var.public_subnet_ids))
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  key_name                    = data.aws_key_pair.default.key_name

  root_block_device {
    volume_size           = 40
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name         = "public-oleg-instance"
    AutoShutdown = "true"
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
  key_name                    = data.aws_key_pair.default.key_name

  root_block_device {
    volume_size           = 40
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name         = "private-oleg-instance-${count.index + 1}"
    AutoShutdown = "true"
  }
}
