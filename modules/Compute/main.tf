# ---------- AWS EC2 Instances ----------
# WebServer Instance 1
resource "aws_instance" "presentation_tier" {
  ami                         = var.ami
  instance_type               = var.instance_type
  count                       = var.instance_count
  subnet_id                   = var.public_subnet[count.index]
  security_groups             = [var.security_groups]
  user_data                   = file("userdata.tpl")
  associate_public_ip_address = true
  key_name                    = aws_key_pair.TF_keypair.id

  tags = {
    Name = "Presentation"
  }
}

# WebServer Instance 2
resource "aws_instance" "app_tier" {
  ami                         = var.ami
  instance_type               = var.instance_type
  count                       = var.instance_count
  subnet_id                   = var.private_subnet_app_tier[count.index]
  security_groups             = [var.app_tier_sg]
  user_data                   = file("userdata.tpl")
  associate_public_ip_address = false
  key_name                    = aws_key_pair.TF_keypair.id

  tags = {
    Name = "Application"
  }
}

# Load Balancer Target Group Attachment
resource "aws_lb_target_group_attachment" "app_tier" {
  count            = var.instance_count
  target_group_arn = var.app_tier_target_group_arn
  target_id        = aws_instance.app_tier[count.index].id
  port             = 80
}

# Load Balancer Target Group Attachment
resource "aws_lb_target_group_attachment" "project_tier" {
  count            = var.instance_count
  target_group_arn = var.project_tier_target_group_arn
  target_id        = aws_instance.presentation_tier[count.index].id
  port             = 80
}

# Key Pair for SSH
resource "aws_key_pair" "TF_keypair" {
  key_name   = "TFKey"
  public_key = file("~/.ssh/tf_keypair.pub")
}