variable "alert_email" {
  type        = string
  description = "Email to receive CloudWatch alerts"
}

variable "cpu_threshold" {
  type        = number
  description = "Threshold for CPUUtilization alarm"
}

variable "memory_threshold" {
  type        = number
  description = "Threshold for MemoryUtilization alarm"
}

variable "ecs_cluster_name" {
  type        = string
  description = "Name of the ECS Cluster"
}

variable "ecs_service_name" {
  type        = string
  description = "Name of the ECS Service"
}
