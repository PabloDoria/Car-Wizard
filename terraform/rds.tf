resource "aws_db_subnet_group" "rds_subnet_group" {
    name        = "rds-subnet-group"
    subnet_ids  = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id] 
    description = "Subnet group for RDS"
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
    vpc_security_group_ids = [aws_security_group.rds_sg.id] # Usar el SG definido en networking.tf
}
