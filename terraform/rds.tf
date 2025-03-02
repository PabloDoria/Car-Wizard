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

    tags = {
        Name = "car-wizard-rds-subnet-group"
    }
}


resource "aws_db_instance" "rds" {
    allocated_storage    = 20
    engine              = "mysql"
    engine_version      = "8.0"
    instance_class      = "db.t4g.micro"
    db_name             = var.rds_db_name
    username           = var.rds_username
    password           = var.rds_password
    skip_final_snapshot = true
    db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
}

