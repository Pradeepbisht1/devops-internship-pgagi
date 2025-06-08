resource "aws_ecr_repository" "backend_repo" {
  name = var.backend_repo_name
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = var.tags
}

resource "aws_ecr_repository" "frontend_repo" {
  name = var.frontend_repo_name
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = var.tags
}
