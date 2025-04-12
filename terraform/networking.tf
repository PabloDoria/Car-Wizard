resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"
    
    enable_dns_hostnames = true
    enable_dns_support   = true

    tags = merge(
        var.common_tags,
        {
            Name = "Car-Wizard-VPC"
        }
    )
}

# Subnets públicas
resource "aws_subnet" "subnet_1" {
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = "10.0.1.0/24"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = true
    
    tags = merge(var.common_tags, {
        Name = "car-wizard-public-1a"
        Type = "public"
    })
}

resource "aws_subnet" "subnet_2" {
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = "10.0.2.0/24"
    availability_zone       = "us-east-1b"
    map_public_ip_on_launch = true
    
    tags = merge(var.common_tags, {
        Name = "car-wizard-public-1b"
        Type = "public"
    })
}

# Subnets privadas
resource "aws_subnet" "subnet_private_1" {
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = "10.0.3.0/24"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = false
    
    tags = merge(var.common_tags, {
        Name = "car-wizard-private-1a"
        Type = "private"
    })
}

resource "aws_subnet" "subnet_private_2" {
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = "10.0.4.0/24"
    availability_zone       = "us-east-1b"
    map_public_ip_on_launch = false
    
    tags = merge(var.common_tags, {
        Name = "car-wizard-private-1b"
        Type = "private"
    })
}

# Elastic IP para NAT Gateway
resource "aws_eip" "nat" {
    domain = "vpc"
    tags = var.common_tags
}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat.id
    subnet_id     = aws_subnet.subnet_1.id
    
    tags = var.common_tags
    
    depends_on = [aws_internet_gateway.igw]
}

# Route Table para subnets privadas
resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat.id
    }

    tags = merge(var.common_tags, {
        Name = "car-wizard-private-rt"
    })
}

# Asociaciones de Route Tables
resource "aws_route_table_association" "private_1" {
    subnet_id      = aws_subnet.subnet_private_1.id
    route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_2" {
    subnet_id      = aws_subnet.subnet_private_2.id
    route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "public_1" {
    subnet_id      = aws_subnet.subnet_1.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_2" {
    subnet_id      = aws_subnet.subnet_2.id
    route_table_id = aws_route_table.public_rt.id
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
