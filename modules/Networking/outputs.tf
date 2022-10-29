output "aws_public_subnet" {
  value = aws_subnet.public_project_subnet.*.id
}

output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "aws_private_subnet" {
  value = aws_subnet.private_project_subnet.*.id
}

output "aws_app_subnet" {
  value = aws_subnet.private_project_subnet_app.*.id
}