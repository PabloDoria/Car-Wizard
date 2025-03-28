resource "aws_cloudwatch_log_group" "ecs_logs" {
    name_prefix       = "/ecs/car-wizard-"
    retention_in_days = 30

    tags = {
        Name        = "car-wizard-ecs-logs"
        Environment = "production"
        Project     = "car-wizard"
    }
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
    name              = "/aws/lambda/${var.lambda_function_name}"
    retention_in_days = 30

    tags = {
        Name        = "car-wizard-lambda-logs"
        Environment = "production"
        Project     = "car-wizard"
    }
}

# Alarma para monitorear errores en Lambda
resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
    alarm_name          = "car-wizard-lambda-errors"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods  = "1"
    metric_name        = "Errors"
    namespace          = "AWS/Lambda"
    period             = "300"
    statistic          = "Sum"
    threshold          = "0"
    alarm_description  = "This metric monitors lambda function errors"
    
    dimensions = {
        FunctionName = var.lambda_function_name
    }

    alarm_actions = []  # Aquí puedes agregar ARNs de SNS topics para notificaciones
}

# Alarma para monitorear el estado de RDS
resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
    alarm_name          = "car-wizard-rds-cpu"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods  = "2"
    metric_name        = "CPUUtilization"
    namespace          = "AWS/RDS"
    period             = "300"
    statistic          = "Average"
    threshold          = "80"
    alarm_description  = "This metric monitors RDS CPU utilization"
    
    dimensions = {
        DBInstanceIdentifier = aws_db_instance.rds.id
    }

    alarm_actions = []  # Aquí puedes agregar ARNs de SNS topics para notificaciones
}