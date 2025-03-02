resource "aws_db_instance" "rds" {
    allocated_storage    = 20
    engine              = "mysql"
    engine_version      = "8.0"
    instance_class      = "db.t3.micro"
    db_name             = var.rds_db_name
    username           = var.rds_username
    password           = var.rds_password
    skip_final_snapshot = true
}
