resource "aws_iam_role" "ecs_task_execution" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

#  Allow ECS execution role to access Secrets Manager
resource "aws_iam_policy" "secret_access_policy" {
  name        = "AllowSecretsManagerRead"
  description = "Allows ECS Task Execution Role to read secrets from Secrets Manager"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = [
        "secretsmanager:GetSecretValue"
      ],
      Resource = "arn:aws:secretsmanager:ap-south-1:311141543250:secret:demo-api-secret-*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_secret_access" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.secret_access_policy.arn
}

#  Additional CloudWatch Permissions
resource "aws_iam_policy" "cloudwatch_alarm_permissions" {
  name        = "AllowPutMetricAlarm"
  description = "Allows ECS tasks to create and manage CloudWatch alarms"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "cloudwatch:PutMetricAlarm",
          "cloudwatch:GetMetricData",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:DeleteAlarms"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_alarm_attach" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.cloudwatch_alarm_permissions.arn
}

#  App Role (if container needs access to other AWS services)
resource "aws_iam_role" "ecs_task_role" {
  name = "ecsTaskAppRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [ {
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}
