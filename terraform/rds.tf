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
    name   = "car-wizard-mysql-parameters"

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

# Script de inicialización de la base de datos
resource "null_resource" "db_init" {
    depends_on = [aws_db_instance.rds]

    triggers = {
        instance_id = aws_db_instance.rds.id
        schema_hash = filesha256("${path.module}/../scripts/database/schema.sql")
    }

    provisioner "local-exec" {
        command = <<-EOT
            mysql -h ${aws_db_instance.rds.endpoint} \
                   -u ${aws_db_instance.rds.username} \
                   -p${random_password.db_password.result} \
                   < ${path.module}/../scripts/database/schema.sql
        EOT
    }
}

output "rds_endpoint" {
    value = aws_db_instance.rds.endpoint
}

