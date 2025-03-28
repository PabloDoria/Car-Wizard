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

resource "aws_lambda_function" "lambda" {
    function_name    = var.lambda_function_name
    role            = aws_iam_role.lambda_role.arn
    filename        = "../lambda/lambda.zip"
    handler         = "lambda_function.lambda_handler"
    runtime         = "python3.8"
    timeout         = 30

    vpc_config {
        subnet_ids         = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
        security_group_ids = [aws_security_group.lambda_sg.id]
    }

    environment {
        variables = {
            DB_HOST     = aws_db_instance.rds.endpoint
            DB_NAME     = var.rds_db_name
            DB_USER     = var.rds_username
            DB_PASSWORD = var.rds_password
        }
    }
}

resource "aws_security_group" "lambda_sg" {
    name_prefix = "lambda-sg-"
    description = "Security group for Lambda function"
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

    tags = {
        Name        = "lambda-security-group"
        Environment = "production"
        Project     = "car-wizard"
    }
}

resource "aws_cloudwatch_event_rule" "lambda_schedule" {
    name                = "trigger-car-data-update"
    description         = "Trigger car data update Lambda function"
    schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
    rule      = aws_cloudwatch_event_rule.lambda_schedule.name
    target_id = "TriggerLambda"
    arn       = aws_lambda_function.lambda.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
    statement_id  = "AllowEventBridgeInvoke"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.lambda.function_name
    principal     = "events.amazonaws.com"
    source_arn    = aws_cloudwatch_event_rule.lambda_schedule.arn
} 