output "vpc_id" {
  description = "ID of the VPC created by the vpc module"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = module.ecs.ecs_cluster_arn
}

output "service_discovery_namespace_id" {
  description = "ID of the Cloud Map private DNS namespace"
  value       = module.ecs.service_discovery_namespace_id
}

output "ecs_service_security_group_id" {
  description = "Security group ID attached to the ECS service"
  value       = aws_security_group.worker.id
}

output "prefect_api_key_secret_arn" {
  description = "ARN of the Secrets Manager secret for the Prefect API key"
  value       = var.secret_arn
  sensitive   = true
}
