variable "aws_region" {
    description = "The AWS region to deploy to"
    type        = string
    default     = "us-east-1"
}

variable "project" {
    default = "car-wizard"
    description = "Nombre del proyecto para etiquetar todos los recursos"
}

variable "environment" {
    description = "Environment name"
    type        = string
    default     = "dev"
}

variable "application_id" {
    default = "car-wizard-app"
    description = "Identificador único de la aplicación para Systems Manager"
}

variable "common_tags" {
    description = "Common tags to apply to all resources"
    type        = map(string)
    default = {
        Project     = "Car Wizard"
        Environment = "dev"
        ManagedBy   = "terraform"
        Application = "car-wizard"
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
    description = "Name of the Lambda function"
    type        = string
    default     = "LoadDataLambda"
}

variable "rds_db_name" {
    description = "Database name"
    type        = string
    default     = "carwizarddb"
}

variable "rds_username" {
    description = "Username for the RDS instance"
    type        = string
    default     = "admin"
}

variable "rds_password" {
    description = "Password for the RDS instance"
    type        = string
    sensitive   = true
}

variable "github_repo" {
    description = "GitHub repository in format owner/repo"
    type        = string
    default     = "PabloDoria/Car-Wizard"
}

variable "s3_data_bucket_name" {
    description = "Name of the S3 bucket for storing Lambda output data"
    type        = string
    default     = "car-wizard-data"
}
