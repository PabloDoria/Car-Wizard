resource "aws_cloudwatch_log_group" "ecs_logs" {
    name_prefix       = "/ecs/car-wizard-"
    retention_in_days = 30

    tags = var.common_tags

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
    name              = "/aws/lambda/${var.lambda_function_name}"
    retention_in_days = 30

    tags = var.common_tags

    lifecycle {
        create_before_destroy = true
        prevent_destroy = false
        ignore_changes = [name]
    }
}

# CloudWatch Event Rule para programar la ejecución diaria del Lambda a las 8:00 AM
resource "aws_cloudwatch_event_rule" "daily_lambda_trigger" {
  name                = "trigger-car-data-update"
  description         = "Ejecuta la función Lambda de obtención de datos diariamente a las 8:00 AM"
  schedule_expression = "cron(0 8 * * ? *)" # 8:00 AM todos los días
  
  tags = var.common_tags
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.daily_lambda_trigger.name
  target_id = "TriggerLambda"
  arn       = aws_lambda_function.data_load.arn
  
  depends_on = [
    aws_lambda_function.data_load
  ]
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.data_load.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_lambda_trigger.arn
  
  depends_on = [
    aws_lambda_function.data_load
  ]
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
    
    tags = var.common_tags
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
    
    tags = var.common_tags
}