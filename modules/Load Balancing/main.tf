# ---------- Application Load Balancer and Target Group ----------
# Application Load Balancer
resource "aws_lb" "ALB" {
  name               = "ProjectALB"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [var.security_groups]

  tags = {
    Name = "Project ALB"
  }
}

# Application Load Balancer Target Group
resource "aws_lb_target_group" "project_lb_tg" {
  name     = "aws-lb-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    healthy_threshold   = var.lb_healthy_threshold
    unhealthy_threshold = var.lb_unhealthy_threshold
    timeout             = var.lb_timeout
    interval            = var.lb_interval
  }
}

# Application Load Balancer Listener Rule
resource "aws_lb_listener" "ALB_Listener" {
  load_balancer_arn = aws_lb.ALB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.project_lb_tg.arn
  }
}

resource "aws_lb" "app_tier_lb" {
  name                       = "app-lb"
  load_balancer_type         = "application"
  internal                   = false
  security_groups            = [var.private_sg]
  subnets                    = var.app_tier_sn
  enable_deletion_protection = false 


  tags = {
    Environment = "project app tier"
  }
}

resource "aws_lb_target_group" "app_tier_lb_tg" {
  name     = "app-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    healthy_threshold   = var.lb_healthy_threshold
    unhealthy_threshold = var.lb_unhealthy_threshold
    timeout             = var.lb_timeout
    interval            = var.lb_interval
  }
}

resource "aws_lb_listener" "app_tier_lb_listener" {
  load_balancer_arn = aws_lb.app_tier_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tier_lb_tg.arn
  }
}