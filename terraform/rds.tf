resource "aws_db_subnet_group" "rds_subnet_group" {
    name       = "car-wizard-rds-subnet-group"
    subnet_ids = [
        aws_subnet.subnet_1.id,
        aws_subnet.subnet_2.id,
        aws_subnet.subnet_3.id,
        aws_subnet.subnet_4.id,
        aws_subnet.subnet_5.id,
        aws_subnet.subnet_6.id
    ]

    tags = var.common_tags
}

resource "aws_db_parameter_group" "mysql_parameters" {
    name_prefix = "car-wizard-params-"
    family      = "mysql8.0"

    parameter {
        name  = "character_set_server"
        value = "utf8mb4"
    }

    parameter {
        name  = "character_set_client"
        value = "utf8mb4"
    }
    
    tags = var.common_tags
}

resource "aws_db_instance" "rds" {
    identifier           = "car-wizard-db"
    allocated_storage    = 20
    engine              = "mysql"
    engine_version      = "8.0"
    instance_class      = "db.t4g.micro"
    db_name             = var.rds_db_name
    username            = var.rds_username
    password            = var.rds_password
    skip_final_snapshot = true
    
    db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
    vpc_security_group_ids = [aws_security_group.rds_sg.id]
    parameter_group_name   = aws_db_parameter_group.mysql_parameters.name
    
    backup_retention_period = 7
    multi_az               = false
    publicly_accessible    = false
    
    tags = var.common_tags
}

output "rds_endpoint" {
    value = aws_db_instance.rds.endpoint
}

