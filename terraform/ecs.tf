resource "aws_ecs_cluster" "ecs_cluster" {
    name = var.ecs_cluster_name
}

resource "aws_ecs_task_definition" "ecs_task" {
    family                   = "car-wizard-task"
    requires_compatibilities = ["FARGATE"]
    network_mode             = "awsvpc"
    memory                   = "512"
    cpu                      = "256"

    container_definitions = jsonencode([
    {
        name      = "car-wizard"
        image     = "${aws_ecr_repository.ecr_repo.repository_url}:latest"
        cpu       = 256
        memory    = 512
        essential = true
        portMappings = [
            {
            containerPort = 80
            hostPort      = 80
            }
        ]
        }
    ])
}

resource "aws_ecs_service" "ecs_service" {
    name            = var.ecs_service_name
    cluster         = aws_ecs_cluster.ecs_cluster.id
    task_definition = aws_ecs_task_definition.ecs_task.arn
    desired_count   = 1
    launch_type     = "FARGATE"
}
