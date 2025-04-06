resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name = "car-wizard/db-credentials"
  description = "Credenciales de la base de datos CarWizard"
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = aws_db_instance.rds.username
    password = random_password.db_password.result
    host     = aws_db_instance.rds.endpoint
    database = aws_db_instance.rds.db_name
    port     = aws_db_instance.rds.port
  })
}

# Política IAM para permitir acceso a los secretos
resource "aws_secretsmanager_secret_policy" "db_credentials_policy" {
  secret_arn = aws_secretsmanager_secret.db_credentials.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = [
            aws_iam_role.ecs_task_execution_role.arn,
            aws_iam_role.lambda_execution_role.arn
          ]
        }
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = aws_secretsmanager_secret.db_credentials.arn
      }
    ]
  })
} 