output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "backend_service_name" {
  description = "ECS Backend service name"
  value       = module.ecs.backend_service_name
}

output "cluster_name" {
  description = "ECS cluster name"
  value       = module.ecs.cluster_name
}
