variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC."
}

variable "cidr_public_subnet" {
  type        = list(string)
  description = "CIDR block for public subnets. it should be an arrany of string"
}

variable "cidr_private_subnet" {
  type        = list(string)
  description = "CIDR block for private subnets. it should be an arrany of string"
}

variable "azs" {
  type        = list(string)
  description = "List of AZ's in which you want to launch your public and private subnets. Number of AZ's must be same as Number of public/private subnets."
}

variable "role_name" {
  type        = string
  description = "Name of the ECS task execution role"
}

variable "secret_arn" {
  type        = string
  description = "ARN of the Secrets Manager secret storing the Prefect API key"


}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "prefect-cluster"
}

variable "sd_namespace" {
  description = "Service Discovery private DNS namespace"
  type        = string
  default     = "default.prefect.local"
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

variable "prefect_api_url" {
  description = "Prefect API URL (e.g. https://api.prefect.cloud/api)"
  type        = string
}

variable "work_pool_name" {
  description = "Name of the Prefect work pool to target"
  type        = string
  default     = "ecs-work-pool"
}

variable "common_tags" {
  type = map(string)
  default = {
    Name        = "prefect-ecs"
    Environment = "dev"
    Team        = "devops"
  }
}
