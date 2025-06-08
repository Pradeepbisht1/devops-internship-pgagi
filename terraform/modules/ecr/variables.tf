variable "backend_repo_name" {
  type        = string
  description = "ECR repo name for backend"
}

variable "frontend_repo_name" {
  type        = string
  description = "ECR repo name for frontend"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to ECR repositories"
  default     = {}
}
