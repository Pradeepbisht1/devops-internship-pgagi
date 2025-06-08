locals {
  backend_image  = "${module.ecr.backend_repo_url}:latest"
  frontend_image = "${module.ecr.frontend_repo_url}:latest"
}

module "vpc" {
  source               = "./modules/vpc"
  cidr_block           = var.vpc_cidr
  public_subnet_a_cidr = var.public_subnet_a_cidr
  public_subnet_b_cidr = var.public_subnet_b_cidr
  az_a                 = var.az_a
  az_b                 = var.az_b
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source                = "./modules/alb"
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = module.vpc.public_subnets
  alb_security_group_id = module.security_groups.alb_sg_id
}

module "iam" {
  source = "./modules/iam"
}

module "ecr" {
  source             = "./modules/ecr"
  backend_repo_name  = "devops-backend"
  frontend_repo_name = "devops-frontend"

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

module "ecs" {
  source              = "./modules/ecs"
  vpc_id              = module.vpc.vpc_id
  public_subnets      = module.vpc.public_subnets
  ecs_security_groups = [module.security_groups.ecs_sg_id]
  alb_listener_arn    = module.alb.listener_arn
  alb_backend_tg_arn  = module.alb.backend_target_group_arn
  alb_frontend_tg_arn = module.alb.frontend_target_group_arn
  execution_role_arn  = module.iam.ecs_task_execution_role_arn
  cluster_name        = "devops-cluster"
  frontend_image      = local.frontend_image
  backend_image       = local.backend_image
  region              = var.aws_region
  api_secret_arn      = module.api_secret.secret_arn
  task_role_arn       = module.iam.task_role_arn  
}

module "monitoring" {
  source            = "./modules/monitoring"
  alert_email       = var.alert_email
  cpu_threshold     = 75
  memory_threshold  = 75
  ecs_cluster_name  = module.ecs.cluster_name
  ecs_service_name  = "backend-service"
}

module "api_secret" {
  source       = "./modules/secrets_manager"
  secret_name  = "demo-api-secret"
  secret_key   = "MY_API_KEY"
  secret_value = var.secret_value
}
