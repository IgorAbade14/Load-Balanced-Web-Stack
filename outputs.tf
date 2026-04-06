output "vpc_id" {
  description = "The ID of the Load-Balanced-Web-Stack VPC"
  value       = module.network.vpc_id

}

output "subnet_a_id" {
  description = "The ID of the Load-Balanced-Web-Stack Subnet A"
  value       = module.network.subnet_a_id
}

output "subnet_b_id" {
  description = "The ID of the Load-Balanced-Web-Stack Subnet B"
  value       = module.network.subnet_b_id
}

output "load_balancer_dns" {
  description = "The DNS name of the Load Balancer"
  value       = module.app.load_balancer_dns
}

output "lb_sg_id" {
  value = module.network.lb_sg_id
}

output "app_sg_id" {
  value = module.network.app_sg_id
}