
# output "load_balancer_dns-name" {
#   description = "The DNS address of the load balancer."
#   value       = aws_lb.lb.dns_name
#   depends_on  = [aws_lb.lb]
# }

output "LB_DNS" {
  value = module.ALB-BASE.alb_lb_dns_name
}

