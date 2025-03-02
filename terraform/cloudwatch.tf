resource "aws_cloudwatch_log_group" "ecs_logs" {
    name_prefix       = "/ecs/car-wizard-"
    retention_in_days = 7

    lifecycle {
        ignore_changes = [name]  
    }

    tags = {
        Name = "ecs-logs"
    }
}