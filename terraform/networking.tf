resource "aws_security_group" "rds_sg" {
    name_prefix = "rds-sg-"
    description = "Security Group for RDS"
    vpc_id      = aws_vpc.vpc.id

    ingress {
        description = "Allow MySQL traffic from ECS"
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        security_groups = [aws_security_group.ecs_sg.id] # Permitir solo desde ECS
    }

    egress {
        description = "Allow outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "rds-security-group"
    }
}

resource "aws_security_group" "ecs_sg" {
    name        = "ecs-security-group"
    description = "Allow traffic from ALB to ECS tasks"
    vpc_id      = aws_vpc.vpc.id

    ingress {
        description = "Allow traffic from ALB"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        security_groups = [aws_security_group.alb_sg.id]
    }

    egress {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "ecs-security-group"
    }
}

