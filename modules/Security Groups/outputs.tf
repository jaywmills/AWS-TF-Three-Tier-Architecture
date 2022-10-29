output "public_ALB" {
  value = aws_security_group.public_ALB.id
}

output "bastion_sg" {
  value = aws_security_group.bastion_sg.id
}
output "public_http_sg" {
  value = aws_security_group.public_http_sg.id
}

output "app_tier_sg" {
  value = aws_security_group.app_tier_sg.id
}


output "private_database_sg" {
  value = aws_security_group.private_database_sg.id
}

output "private_ALB" {
  value = aws_security_group.private_ALB.id
}