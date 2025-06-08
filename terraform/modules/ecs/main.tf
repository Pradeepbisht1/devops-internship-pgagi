resource "aws_cloudwatch_log_group" "frontend_log_group" {
  name              = "/ecs/frontend"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "backend_log_group" {
  name              = "/ecs/backend"
  retention_in_days = 7
}

resource "aws_ecs_cluster" "main" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "frontend" {
  family                   = "frontend-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([{
    name      = "frontend"
    image     = var.frontend_image
    essential = true
    portMappings = [{
      containerPort = 3000
      protocol      = "tcp"
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/frontend"
        awslogs-region        = var.region
        awslogs-stream-prefix = "ecs"
      }
    }
    secrets = [{
      name      = "MY_API_KEY"
      valueFrom = var.api_secret_arn
    }]
  }])
}

resource "aws_ecs_task_definition" "backend" {
  family                   = "backend-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([{
    name      = "backend"
    image     = var.backend_image
    essential = true
    portMappings = [{
      containerPort = 8000
      protocol      = "tcp"
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/backend"
        awslogs-region        = var.region
        awslogs-stream-prefix = "ecs"
      }
    }
    secrets = [{
      name      = "MY_API_KEY"
      valueFrom = var.api_secret_arn
    }]
  
  }])
}

resource "aws_ecs_service" "frontend" {
  name            = "frontend-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.frontend.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.public_subnets
    security_groups = var.ecs_security_groups
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.alb_frontend_tg_arn
    container_name   = "frontend"
    container_port   = 3000
  }

  depends_on = [aws_ecs_task_definition.frontend]
}

resource "aws_ecs_service" "backend" {
  name            = "backend-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.public_subnets
    security_groups = var.ecs_security_groups
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.alb_backend_tg_arn
    container_name   = "backend"
    container_port   = 8000
  }

  depends_on = [aws_ecs_task_definition.backend]
}
