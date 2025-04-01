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

resource "aws_lambda_function" "data_load" {
    function_name    = var.lambda_function_name
    role            = aws_iam_role.lambda_role.arn
    filename        = "${path.module}/../lambda/lambda_function.py"
    handler         = "lambda_function.lambda_handler"
    runtime         = "python3.9"
    timeout         = 30

    vpc_config {
        subnet_ids         = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
        security_group_ids = [aws_security_group.lambda_sg.id]
    }

    environment {
        variables = {
            RDS_ENDPOINT = aws_db_instance.rds.endpoint
            RDS_DATABASE = var.rds_db_name
            RDS_USERNAME = var.rds_username
            RDS_PASSWORD = var.rds_password
        }
    }

    tags = var.common_tags
    
    lifecycle {
        create_before_destroy = true
    }
    
    # Al establecer una dependencia, garantizamos un orden específico
    depends_on = [
        aws_iam_role.lambda_role,
        aws_security_group.lambda_sg
    ]
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

resource "aws_cloudwatch_event_rule" "schedule" {
    name                = "trigger-car-data-update"
    description         = "Trigger Lambda function to update car data"
    schedule_expression = "rate(1 day)"

    tags = var.common_tags
}

resource "aws_cloudwatch_event_target" "lambda_target" {
    rule      = aws_cloudwatch_event_rule.schedule.name
    target_id = "TriggerLambda"
    arn       = aws_lambda_function.data_load.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
    statement_id  = "AllowEventBridgeInvoke"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.data_load.function_name
    principal     = "events.amazonaws.com"
    source_arn    = aws_cloudwatch_event_rule.schedule.arn
} 