variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "prefect-cluster"
}

variable "vpc_id" {
  description = "VPC ID for service discovery"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for Fargate tasks"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs to attach to the service"
  type        = list(string)
}

variable "sd_namespace" {
  description = "Service Discovery private DNS namespace"
  type        = string
  default     = "default.prefect.local"
}

variable "task_execution_role_arn" {
  description = "ARN of the IAM role for ECS task execution"
  type        = string
}

variable "worker_image" {
  description = "Container image for the Prefect worker"
  type        = string
  default     = "prefecthq/prefect:2-latest"
}

variable "task_cpu" {
  description = "CPU units for the Fargate task"
  type        = number
  default     = 512
}

variable "task_memory" {
  description = "Memory (MiB) for the Fargate task"
  type        = number
  default     = 1024
}

variable "prefect_api_key_secret_arn" {
  description = "ARN of the Secrets Manager secret holding PREFECT_API_KEY"
  type        = string
}

variable "prefect_api_url" {
  description = "Prefect API URL"
  type        = string
}

variable "work_pool_name" {
  description = "Name of the Prefect work pool to target"
  type        = string
  default     = "ecs-work-pool"
}

variable "common_tags" {
  description = "Common tags to apply to all ECS resources"
  type        = map(string)
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}
