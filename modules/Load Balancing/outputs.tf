output "lb_dns_name" {
  value = aws_lb.ALB.dns_name
}

output "lb_endpoint" {
  value = aws_lb.ALB.dns_name
}

output "project_lb_tg" {
  value = aws_lb_target_group.project_lb_tg.arn
}

output "app_tier_lb_tg" {
  value = aws_lb_target_group.app_tier_lb_tg.arn
}
