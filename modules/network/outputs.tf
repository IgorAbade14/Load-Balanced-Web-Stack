output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_a_id" {
  value = aws_subnet.subnet_a.id
}

output "subnet_b_id" {
  value = aws_subnet.subnet_b.id
}

output "lb_sg_id" {
  value = aws_security_group.lb_sg.id
}

output "app_sg_id" {
  value = aws_security_group.app_sg.id
}