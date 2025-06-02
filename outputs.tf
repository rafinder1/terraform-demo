output "load_balancer_dns" {
  description = "Adres DNS Load Balancera"
  value       = aws_lb.web.dns_name
}

output "vpc_id" {
  description = "ID utworzonego VPC"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "IDs utworzonych publicznych podsieci"
  value       = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

output "auto_scaling_group_name" {
  description = "Nazwa utworzonej Auto Scaling Group"
  value       = aws_autoscaling_group.web.name
}