output "secret_arn" {
  value = aws_secretsmanager_secret.api_secret.arn
}
