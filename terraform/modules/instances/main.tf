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

# Public Instance (1)
resource "aws_instance" "public" {
  count                       = var.public_instance_count
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = element([aws_subnet.public_1.id, aws_subnet.public_2.id], count.index % 2)
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.public_sg.id]

  tags = {
    Name = "public-instance-${count.index + 1}"
  }
}

# Private Instances (3)
resource "aws_instance" "private" {
  count                  = var.private_instance_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = element([aws_subnet.private_1.id, aws_subnet.private_2.id], count.index % 2)
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  tags = {
    Name = "private-instance-${count.index + 1}"
  }
}
