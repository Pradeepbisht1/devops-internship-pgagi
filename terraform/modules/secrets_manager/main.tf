resource "aws_secretsmanager_secret" "api_secret" {
  name = var.secret_name
}

resource "aws_secretsmanager_secret_version" "api_secret_value" {
  secret_id     = aws_secretsmanager_secret.api_secret.id
  secret_string = jsonencode({
    (var.secret_key) = var.secret_value
  })
}
