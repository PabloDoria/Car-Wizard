variable "aws_region" {
    default = "us-east-1"
}

variable "project" {
    default = "car-wizard"
    description = "Nombre del proyecto para etiquetar todos los recursos"
}

variable "environment" {
    default = "production"
    description = "Entorno de despliegue"
}

variable "application_id" {
    default = "car-wizard-app"
    description = "Identificador único de la aplicación para Systems Manager"
}

variable "common_tags" {
    description = "Tags comunes para todos los recursos"
    type = map(string)
    default = {
        Project     = "car-wizard"
        Environment = "production"
        ManagedBy   = "terraform"
        Application = "car-wizard-app"
    }
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

variable "github_repo" {
    description = "GitHub repository in format owner/repo"
    type        = string
    default     = "PabloDoria/Car-Wizard"
}

variable "s3_data_bucket_name" {
    description = "Nombre del bucket S3 para almacenar los datos procesados"
    type        = string
    default     = "car-wizard-data"
}
