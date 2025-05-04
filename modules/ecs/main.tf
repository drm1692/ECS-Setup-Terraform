# Create ECS Cluster
resource "aws_ecs_cluster" "prefect-cluster" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = var.common_tags
}


resource "aws_service_discovery_private_dns_namespace" "this" {
  name        = var.sd_namespace
  description = "Prefect service discovery namespace"
  vpc         = var.vpc_id
  tags        = var.common_tags
}

# Task Defination
resource "aws_ecs_task_definition" "prefect_worker" {
  family                   = "${var.cluster_name}-dev-worker"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = var.task_execution_role_arn
  task_role_arn            = var.task_execution_role_arn

  container_definitions = jsonencode([{
    name      = "dev-worker"
    image     = var.worker_image
    cpu       = var.task_cpu
    memory    = var.task_memory
    essential = true

    command = [
      "prefect",
      "worker",
      "start",
      "-p", var.work_pool_name,
      "--type", "process"
    ]


    secrets = [
      {
        name      = "PREFECT_API_KEY"
        valueFrom = "${var.prefect_api_key_secret_arn}:prefect-api-key::"
      }
    ]
    environment = [

      {
        name  = "PREFECT_API_URL"
        value = var.prefect_api_url
      },
      {
        name  = "PREFECT_WORK_POOL"
        value = var.work_pool_name
      }
    ]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-create-group  = "true"
        awslogs-group         = "/ecs/${var.cluster_name}"
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "dev-worker"
      }
    }

    portMappings = []
  }])
}

#Service Discovery
resource "aws_service_discovery_service" "prefect_worker" {
  name         = "${var.cluster_name}-dev-worker"
  namespace_id = aws_service_discovery_private_dns_namespace.this.id

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.this.id
    dns_records {
      type = "A"
      ttl  = 60
    }
  }
  tags = var.common_tags
}


# ECS Service
resource "aws_ecs_service" "prefect_worker" {
  name            = "dev-worker"
  cluster         = aws_ecs_cluster.prefect-cluster.id
  task_definition = aws_ecs_task_definition.prefect_worker.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = false
  }

  service_registries {
    registry_arn   = aws_service_discovery_service.prefect_worker.arn
    container_name = "dev-worker"
  }

  tags = var.common_tags

  depends_on = [
    aws_service_discovery_private_dns_namespace.this
  ]
}
