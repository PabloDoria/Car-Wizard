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

    tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
    role       = aws_iam_role.ecs_execution_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_execution_ecr_policy" {
    role       = aws_iam_role.ecs_execution_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "ecs_execution_logs_policy" {
    role       = aws_iam_role.ecs_execution_role.name
    policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_ecs_cluster" "ecs_cluster" {
    name = "car-wizard-cluster" # 1
    
    tags = var.common_tags
}


resource "aws_ecs_task_definition" "ecs_task" {
    family                   = "car-wizard-task"
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    execution_role_arn       = aws_iam_role.ecs_execution_role.arn
    cpu                      = "256"
    memory                   = "512"

    container_definitions = jsonencode([
        {
        name      = "car-wizard-container"
        image     = "${aws_ecr_repository.ecr_repo.repository_url}:latest"
        cpu       = 256
        memory    = 512
        essential = true

        portMappings = [
            {
            containerPort = 80
            hostPort      = 80
            protocol      = "tcp"
            }
        ]

        logConfiguration = {
            logDriver = "awslogs"
            options = {
            "awslogs-group"         = "/ecs/car-wizard"
            "awslogs-region"        = "us-east-1"
            "awslogs-stream-prefix" = "ecs"
            }
        }
        }
    ])

    tags = var.common_tags
}


resource "aws_ecs_service" "ecs_service" {
    name            = "car-wizard-service"
    cluster         = aws_ecs_cluster.ecs_cluster.id
    task_definition = aws_ecs_task_definition.ecs_task.arn
    desired_count   = 1
    launch_type     = "FARGATE"

    force_new_deployment = true
    
    deployment_maximum_percent         = 200
    deployment_minimum_healthy_percent = 100

    network_configuration {
        subnets          = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
        security_groups  = [aws_security_group.ecs_tasks_sg.id]
        assign_public_ip = true
    }

    load_balancer {
        target_group_arn = aws_lb_target_group.alb_target.arn
        container_name   = "car-wizard-container"
        container_port   = 80
    }

    lifecycle {
        create_before_destroy = true
        ignore_changes = [
            task_definition,
            desired_count
        ]
    }

    tags = var.common_tags
}
