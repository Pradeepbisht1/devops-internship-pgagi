output "ecs_cluster_id" {
  value = aws_ecs_cluster.main.id
}

output "frontend_service_name" {
  value = aws_ecs_service.frontend.name
}

output "backend_service_name" {
  value = aws_ecs_service.backend.name
}

output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}
