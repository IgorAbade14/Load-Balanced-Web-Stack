output "load_balancer_dns" {
  value = aws_lb.web_stack_lb.dns_name # O nome do recurso LB que criamos antes
}