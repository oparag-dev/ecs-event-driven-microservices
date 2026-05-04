output "alb_arn" {
  description = "ARN of the Application Load Balancer."
  value       = aws_lb.this.arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer."
  value       = aws_lb.this.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the Application Load Balancer."
  value       = aws_lb.this.zone_id
}

output "http_listener_arn" {
  description = "ARN of the HTTP listener."
  value       = aws_lb_listener.http.arn
}

output "target_group_arns" {
  description = "Map of service names to target group ARNs."
  value = {
    for service, target_group in aws_lb_target_group.services :
    service => target_group.arn
  }
}

output "target_group_names" {
  description = "Map of service names to target group names."
  value = {
    for service, target_group in aws_lb_target_group.services :
    service => target_group.name
  }
}