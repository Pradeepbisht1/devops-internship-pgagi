variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for ECS services"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "ecs_security_groups" {
  description = "List of security group IDs for ECS tasks"
  type        = list(string)
}

variable "alb_listener_arn" {
  description = "ARN of the Application Load Balancer listener"
  type        = string
}

variable "alb_backend_tg_arn" {
  description = "ARN of the backend target group"
  type        = string
}

variable "alb_frontend_tg_arn" {
  description = "ARN of the frontend target group"
  type        = string
}

variable "execution_role_arn" {
  description = "IAM role ARN used by ECS for task execution (pull images, logs)"
  type        = string
}

variable "task_role_arn" {
  description = "IAM role ARN for the ECS task to access AWS services like Secrets Manager"
  type        = string
}

variable "frontend_image" {
  description = "Docker image for the frontend container"
  type        = string
}

variable "backend_image" {
  description = "Docker image for the backend container"
  type        = string
}

variable "region" {
  description = "AWS region for deployment and logging"
  type        = string
}

variable "api_secret_arn" {
  description = "ARN of the secret stored in AWS Secrets Manager"
  type        = string
}
