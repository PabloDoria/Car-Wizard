data "aws_caller_identity" "current" {}

resource "aws_iam_role" "lambda_role" {
    name = "LambdaExecutionRole"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
            }
        ]
    })

    lifecycle {
        create_before_destroy = true
    }

    tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_vpc" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy" "lambda_rds_access" {
    name = "lambda_rds_access"
    role = aws_iam_role.lambda_role.id

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "rds-db:connect"
                ]
                Resource = [
                    "arn:aws:rds-db:${var.aws_region}:${data.aws_caller_identity.current.account_id}:dbuser:${aws_db_instance.rds.resource_id}/${var.rds_username}"
                ]
            }
        ]
    })
}

# Función Lambda para generar el schema
resource "aws_lambda_function" "schema_generator" {
  filename         = "lambda_function_schema.zip"
  function_name    = "car-wizard-schema-generator"
  role            = aws_iam_role.lambda_role.arn
  handler         = "generate_schema.generate_schema_file"
  runtime         = "python3.9"
  timeout         = 300
  memory_size     = 256

  environment {
    variables = {
      DB_SECRET_ARN = aws_secretsmanager_secret.db_credentials.arn
    }
  }
}

# Función Lambda para inicializar la base de datos
resource "aws_lambda_function" "db_initializer" {
  filename         = "lambda_function_init.zip"
  function_name    = "car-wizard-db-initializer"
  role            = aws_iam_role.lambda_role.arn
  handler         = "db_initializer.lambda_handler"
  runtime         = "python3.9"
  timeout         = 300
  memory_size     = 256

  environment {
    variables = {
      DB_SECRET_ARN = aws_secretsmanager_secret.db_credentials.arn
    }
  }

  vpc_config {
    subnet_ids         = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
}

# Función Lambda para cargar datos
resource "aws_lambda_function" "data_loader" {
  filename         = "lambda_function_data.zip"
  function_name    = "car-wizard-data-loader"
  role            = aws_iam_role.lambda_role.arn
  handler         = "main.lambda_handler"
  runtime         = "python3.9"
  timeout         = 300
  memory_size     = 512

  environment {
    variables = {
      DB_SECRET_ARN = aws_secretsmanager_secret.db_credentials.arn
    }
  }

  vpc_config {
    subnet_ids         = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
}

# Regla de EventBridge para ejecutar el generador de schema
resource "aws_cloudwatch_event_rule" "schema_generator" {
  name                = "car-wizard-schema-generator"
  description         = "Ejecuta el generador de schema una vez al día"
  schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "schema_generator" {
  rule      = aws_cloudwatch_event_rule.schema_generator.name
  target_id = "SchemaGenerator"
  arn       = aws_lambda_function.schema_generator.arn
}

resource "aws_lambda_permission" "schema_generator" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.schema_generator.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schema_generator.arn
}

# Regla de EventBridge para ejecutar el inicializador de la base de datos
resource "aws_cloudwatch_event_rule" "db_initializer" {
  name                = "car-wizard-db-initializer"
  description         = "Se dispara cuando el schema se ha generado correctamente"
  event_pattern = jsonencode({
    source      = ["aws.lambda"],
    detail-type = ["Lambda Function Invocation Result"],
    detail = {
      functionName = [aws_lambda_function.schema_generator.function_name],
      status      = ["SUCCESS"]
    }
  })
}

resource "aws_cloudwatch_event_target" "db_initializer" {
  rule      = aws_cloudwatch_event_rule.db_initializer.name
  target_id = "DBInitializer"
  arn       = aws_lambda_function.db_initializer.arn
}

resource "aws_lambda_permission" "db_initializer" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.db_initializer.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.db_initializer.arn
}

# Regla de EventBridge para ejecutar el cargador de datos
resource "aws_cloudwatch_event_rule" "data_loader" {
  name                = "car-wizard-data-loader"
  description         = "Se dispara cuando la base de datos se ha inicializado correctamente"
  event_pattern = jsonencode({
    source      = ["aws.lambda"],
    detail-type = ["Lambda Function Invocation Result"],
    detail = {
      functionName = [aws_lambda_function.db_initializer.function_name],
      status      = ["SUCCESS"]
    }
  })
}

resource "aws_cloudwatch_event_target" "data_loader" {
  rule      = aws_cloudwatch_event_rule.data_loader.name
  target_id = "DataLoader"
  arn       = aws_lambda_function.data_loader.arn
}

resource "aws_lambda_permission" "data_loader" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.data_loader.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.data_loader.arn
}

resource "aws_security_group" "lambda_sg" {
    name_prefix = "lambda-sg-"
    description = "Security group for Lambda functions"
    vpc_id      = aws_vpc.vpc.id

    ingress {
        description     = "Allow MySQL traffic to RDS"
        from_port       = 3306
        to_port         = 3306
        protocol        = "tcp"
        security_groups = [aws_security_group.rds_sg.id]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = var.common_tags
} 