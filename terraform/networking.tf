resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"
    
    enable_dns_hostnames = true
    enable_dns_support   = true

    tags = var.common_tags
}

resource "aws_subnet" "subnet_1" {
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = "10.0.1.0/24"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = true
    
    tags = var.common_tags
}

resource "aws_subnet" "subnet_2" {
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = "10.0.2.0/24"
    availability_zone       = "us-east-1b"
    map_public_ip_on_launch = true
    
    tags = var.common_tags
}

resource "aws_subnet" "subnet_3" {
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = "10.0.3.0/24"
    availability_zone       = "us-east-1c"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_4" {
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = "10.0.4.0/24"
    availability_zone       = "us-east-1d"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_5" {
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = "10.0.5.0/24"
    availability_zone       = "us-east-1e"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_6" {
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = "10.0.6.0/24"
    availability_zone       = "us-east-1f"
    map_public_ip_on_launch = true
}


resource "aws_security_group" "alb_sg" {
    name_prefix = "alb-sg-"
    description = "Security Group for ALB"
    vpc_id      = aws_vpc.vpc.id

    ingress {
        description = "Allow HTTP traffic from anywhere"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allow HTTPS traffic from anywhere"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "Allow outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = var.common_tags
}

resource "aws_security_group" "rds_sg" {
    name_prefix = "rds-sg-"
    description = "Security Group for RDS"
    vpc_id      = aws_vpc.vpc.id

    ingress {
        description     = "Allow MySQL traffic from ECS tasks"
        from_port       = 3306
        to_port         = 3306
        protocol        = "tcp"
        security_groups = [aws_security_group.ecs_tasks_sg.id]
    }

    tags = var.common_tags
}

resource "aws_security_group" "ecs_tasks_sg" {
    name_prefix = "ecs-tasks-sg-"
    description = "Security Group for ECS Tasks"
    vpc_id      = aws_vpc.vpc.id

    ingress {
        description     = "Allow inbound traffic from ALB"
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        security_groups = [aws_security_group.alb_sg.id]
    }

    egress {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = var.common_tags
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id

    tags = var.common_tags
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = var.common_tags
}

resource "aws_route_table_association" "subnet_1_association" {
    subnet_id      = aws_subnet.subnet_1.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "subnet_2_association" {
    subnet_id      = aws_subnet.subnet_2.id
    route_table_id = aws_route_table.public_rt.id
}
