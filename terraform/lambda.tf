data "aws_caller_identity" "current" {}

resource "aws_iam_role" "lambda_role" {
    name = "LambdaExecutionRole"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
            }
        ]
    })

    lifecycle {
        create_before_destroy = true
    }

    tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_vpc" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy" "lambda_rds_access" {
    name = "lambda_rds_access"
    role = aws_iam_role.lambda_role.id

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "rds-db:connect"
                ]
                Resource = [
                    "arn:aws:rds-db:${var.aws_region}:${data.aws_caller_identity.current.account_id}:dbuser:${aws_db_instance.rds.resource_id}/${var.rds_username}"
                ]
            }
        ]
    })
}

# Primera etapa: crear la Lambda con código mínimo
resource "aws_lambda_function" "data_load" {
    function_name    = var.lambda_function_name
    role            = aws_iam_role.lambda_role.arn
    
    # Usar un código mínimo en línea para evitar problemas de tamaño
    filename        = "${path.module}/lambda_dummy.zip"
    source_code_hash = filebase64sha256("${path.module}/lambda_dummy.zip")
    handler         = "lambda_function.lambda_handler"
    runtime         = "python3.9"
    timeout         = 300 # Aumentado a 5 minutos para permitir tiempo suficiente para la obtención de datos
    memory_size     = 512 # Aumentado para manejar procesamiento de DataFrames con pandas

    # Crear una versión mínima del Lambda durante el apply
    provisioner "local-exec" {
        command = <<EOT
        mkdir -p ${path.module}/tmp_lambda
        echo 'def lambda_handler(event, context):
            return {"statusCode": 200, "body": "Hello from Lambda!"}
        ' > ${path.module}/tmp_lambda/lambda_function.py
        cd ${path.module}/tmp_lambda
        zip -j ../lambda_dummy.zip lambda_function.py
        cd ..
        rm -rf ${path.module}/tmp_lambda
        EOT
        interpreter = ["bash", "-c"]
    }

    vpc_config {
        subnet_ids         = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
        security_group_ids = [aws_security_group.lambda_sg.id]
    }

    environment {
        variables = {
            RDS_ENDPOINT = aws_db_instance.rds.endpoint
            RDS_DATABASE = var.rds_db_name
            RDS_USERNAME = var.rds_username
            RDS_PASSWORD = var.rds_password
            S3_DATA_BUCKET = var.s3_data_bucket_name
            S3_CODE_BUCKET = "car-wizard-code"
            LOG_LEVEL    = "INFO"
        }
    }

    tags = var.common_tags
    
    lifecycle {
        create_before_destroy = true
        ignore_changes = [
            filename,
            source_code_hash
        ]
    }
    
    depends_on = [
        aws_iam_role.lambda_role,
        aws_security_group.lambda_sg
    ]
}

resource "aws_security_group" "lambda_sg" {
    name_prefix = "lambda-sg-"
    description = "Security group for Lambda functions"
    vpc_id      = aws_vpc.vpc.id

    ingress {
        description     = "Allow MySQL traffic to RDS"
        from_port       = 3306
        to_port         = 3306
        protocol        = "tcp"
        security_groups = [aws_security_group.rds_sg.id]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = var.common_tags
} 