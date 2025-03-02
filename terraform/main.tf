terraform {
        required_version = ">= 1.0.0"
}

    # Llamando a los recursos definidos en otros archivos
    module "ecr" {
        source = "./ecr.tf"
    }

    module "ecs" {
        source = "./ecs.tf"
    }

    module "rds" {
        source = "./rds.tf"
    }

    module "lambda" {
        source = "./lambda.tf"
    }

    module "networking" {
        source = "./networking.tf"
    }

    module "cloudwatch" {
        source = "./cloudwatch.tf"
    }

    module "alb" {
        source = "./alb.tf"
    }
