resource "aws_security_group" "lb_sg" {
  name        = "oleg-alb-sg"
  description = "Allow HTTP"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_lb" "alb" {
  name               = "oleg-ingress-alb"
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [aws_security_group.lb_sg.id]
  enable_deletion_protection = false
  tags = { Name = "oleg-ingress-alb" }
}

resource "aws_lb_target_group" "tg" {
  name        = "oleg-ingress-tg"
  port        = var.nodeport
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = "200"
  }
  tags = { Name = "oleg-ingress-tg" }
}

resource "aws_lb_target_group_attachment" "nodes" {
  for_each = var.target_ips
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = each.value
  port             = var.nodeport
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}