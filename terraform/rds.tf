resource "aws_db_subnet_group" "rds_subnet_group" {
    name        = "rds-subnet-group"
    subnet_ids  = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id] 
    description = "Subnet group for RDS"
}

resource "aws_security_group" "rds_sg" {
    name        = "rds-security-group"
    description = "Allow ECS traffic to RDS"
    vpc_id      = aws_vpc.vpc.id

    ingress {
        description = "Allow traffic from ECS"
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        security_groups = [aws_security_group.ecs_sg.id]  # Se usa security_groups en lugar de source_security_group_id
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

resource "aws_db_instance" "rds" {
    identifier           = "my-rds-instance"
    db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
    allocated_storage    = 20
    engine              = "mysql"
    engine_version      = "8.0"
    instance_class      = "db.t3.small"
    db_name             = var.rds_db_name
    username           = var.rds_username
    password           = var.rds_password
    skip_final_snapshot = true
    vpc_security_group_ids = [aws_security_group.rds_sg.id] # Asegura que RDS tenga acceso
}
