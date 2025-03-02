resource "aws_cloudwatch_log_group" "ecs_logs" {
    name = "/ecs/car-wizard"
    retention_in_days = 30
    lifecycle {
        prevent_destroy = true
    }
}
