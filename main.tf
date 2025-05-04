module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = var.vpc_cidr
  vpc_name            = var.vpc_name
  cidr_public_subnet  = var.cidr_public_subnet
  cidr_private_subnet = var.cidr_private_subnet
  azs                 = var.azs
  common_tags         = var.common_tags
}

module "iam" {
  source      = "./modules/iam"
  role_name   = var.role_name
  secret_arn  = var.secret_arn
  common_tags = var.common_tags
}

data "aws_secretsmanager_secret" "secret" {
  arn = var.secret_arn
}

data "aws_secretsmanager_secret_version" "prefect_api_key" {
  secret_id = data.aws_secretsmanager_secret.secret.id
}

module "ecs" {
  source                     = "./modules/ecs"
  cluster_name               = var.cluster_name
  vpc_id                     = module.vpc.vpc_id
  private_subnet_ids         = module.vpc.private_subnets
  security_group_ids         = [aws_security_group.worker.id]
  sd_namespace               = var.sd_namespace
  task_execution_role_arn    = module.iam.ecs_task_execution_role_arn
  prefect_api_key_secret_arn = data.aws_secretsmanager_secret.secret.arn
  prefect_api_url            = var.prefect_api_url
  work_pool_name             = var.work_pool_name
  common_tags                = var.common_tags
}

# Security group for workers
resource "aws_security_group" "worker" {
  name        = "prefect-ecs-worker"
  description = "Allow outbound to Prefect Cloud"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.common_tags
}
