data "aws_iam_policy_document" "ecs_task_execution_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ecs_task_execution" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_assume_role.json
  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec_managed" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "ecs_task_secret_access" {
  name        = "${var.role_name}-secrets-access"
  description = "Allow ECS tasks to retrieve Prefect API key from Secrets Manager"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["secretsmanager:GetSecretValue", "kms:Decrypt"]
      Resource = var.secret_arn
    }]
  })
  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "ecs_task_secret_access_attach" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.ecs_task_secret_access.arn
}

resource "aws_iam_policy" "ecs_task_logs" {
  name        = "${var.role_name}-logs"
  description = "Allow ECS tasks to create CloudWatch log groups/streams and put log events"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = "*"
    }]
  })
  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "ecs_task_logs_attach" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.ecs_task_logs.arn
}