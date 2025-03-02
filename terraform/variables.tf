variable "aws_region" {
    default = "us-east-1"
}

variable "ecr_repository_name" {
    default = "car-wizard"    
}

variable "ecs_cluster_name" {
    default = "car-wizard-cluster"
}

variable "ecs_service_name" {
    default = "car-wizard-service"
}

variable "lambda_function_name" {
    default = "LoadDataLambda"
}

variable "rds_db_name" {
    default = "carwizarddb"
}

variable "rds_username" {
    default = "admin"
}

variable "rds_password" {
    default = "SuperSecurePassword123!"
}
