vpc_cidr            = "10.0.0.0/16"
vpc_name            = "prefect-ecs"
cidr_public_subnet  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
cidr_private_subnet = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
azs                 = ["us-east-1a", "us-east-1b", "us-east-1c"]

role_name = "ecsTaskExecutionRole"
secret_arn = "arn:aws:secretsmanager:us-east-1:746669205142:secret:prefect-api-key-54k8Bd"

cluster_name = "prefect"
sd_namespace = "default.prefect.local"
prefect_api_url = "https://api.prefect.cloud/api/accounts/76827f44-4457-45b0-b451-ebf5d87c420a/workspaces/af3c2fbc-53fe-4a69-9b04-ff7cffc71650"
work_pool_name = "ecs-work-pool"


