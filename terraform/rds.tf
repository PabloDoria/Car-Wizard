resource "aws_db_subnet_group" "rds_subnet_group" {
    name       = "car-wizard-db-subnet-group"
    subnet_ids = [
        aws_subnet.subnet_3.id,
        aws_subnet.subnet_4.id
    ]

    tags = var.common_tags
}

resource "aws_db_parameter_group" "mysql_parameters" {
    family = "mysql8.0"
    name   = "car-wizard-mysql-parameters-${formatdate("YYYYMMDDHHmmss", timestamp())}"

    parameter {
        name  = "character_set_server"
        value = "utf8mb4"
    }

    parameter {
        name  = "character_set_database"
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
    engine              = "mysql"
    engine_version      = "8.0"
    instance_class      = "db.t3.micro"
    allocated_storage   = 20
    storage_type        = "gp2"
    
    db_name             = "carwizarddb"
    username            = "admin"
    password            = random_password.db_password.result
    
    vpc_security_group_ids = [aws_security_group.rds_sg.id]
    db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
    
    parameter_group_name   = aws_db_parameter_group.mysql_parameters.name
    
    skip_final_snapshot = true
    
    tags = var.common_tags
}

output "rds_endpoint" {
    value = aws_db_instance.rds.endpoint
    description = "Endpoint de la base de datos RDS"
}

output "rds_username" {
    value = aws_db_instance.rds.username
    description = "Usuario de la base de datos RDS"
    sensitive = true
}

