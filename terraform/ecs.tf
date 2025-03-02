resource "aws_iam_role" "ecs_execution_role" {
    name = "ecsTaskExecutionRole"

    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
        {
            Effect = "Allow",
            Principal = {
            Service = "ecs-tasks.amazonaws.com"
            },
            Action = "sts:AssumeRole"
        }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
    role       = aws_iam_role.ecs_execution_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "ecs_task" {
    family                   = "car-wizard-task"
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    execution_role_arn       = aws_iam_role.ecs_execution_role.arn  # 🚀 Agregamos esto
    cpu                      = "256"
    memory                   = "512"
    
    container_definitions = jsonencode([
    {
        name      = "car-wizard-container",
        image     = "${aws_ecr_repository.ecr_repo.repository_url}:latest",
        cpu       = 256,
        memory    = 512,
        essential = true,
        networkMode = "awsvpc",
        logConfiguration = {
            logDriver = "awslogs",
            options = {
            "awslogs-group" = "/ecs/car-wizard"
            "awslogs-region" = "us-east-1"
            "awslogs-stream-prefix" = "ecs"
            }
        }
        }
    ])
}
