resource "aws_resourcegroups_group" "car_wizard" {
    name = "car-wizard-resources"
    description = "Recursos de la aplicacion Car Wizard"

    resource_query {
        query = jsonencode({
            ResourceTypeFilters = [
                "AWS::AllSupported"
            ],
            TagFilters = [
                {
                    Key = "Application",
                    Values = ["car-wizard-app"]
                }
            ]
        })
    }

    tags = var.common_tags
    
    lifecycle {
        create_before_destroy = true
        # Permitir recreación completa si hay problemas
        prevent_destroy = false
        # Ignorar cambios en estos atributos
        ignore_changes = [description, resource_query]
    }
}

resource "aws_ssm_document" "app_config" {
    name            = "car-wizard-app-config"
    document_type   = "ApplicationConfiguration"
    document_format = "JSON"
    
    content = jsonencode({
        schemaVersion = "2.0"
        description   = "Configuración de la aplicación Car Wizard"
        parameters    = {}
        mainSteps    = [
            {
                name = "car-wizard",
                action = "aws:appConfig",
                inputs = {
                    applications = [
                        {
                            name = var.application_id
                            type = "AWS::ResourceGroups::Group"
                            resourceGroup = aws_resourcegroups_group.car_wizard.name
                            componentTypes = [
                                "AWS::ECS::Service",
                                "AWS::RDS::DBInstance",
                                "AWS::Lambda::Function",
                                "AWS::ElasticLoadBalancingV2::LoadBalancer"
                            ]
                            tags = var.common_tags
                        }
                    ]
                }
            }
        ]
        documentRequires = [
            {
                name = "runtimePlatform",
                operatingSystem = ["Windows"],
                architectures = ["x86_64"]
            }
        ]
    })

    tags = var.common_tags
    
    lifecycle {
        create_before_destroy = true
    }
}

# Crear un dashboard en CloudWatch para visualizar todos los recursos
resource "aws_cloudwatch_dashboard" "car_wizard" {
    dashboard_name = "car-wizard-dashboard"
    
    dashboard_body = jsonencode({
        widgets = [
            {
                type = "metric"
                x    = 0
                y    = 0
                width = 12
                height = 6
                properties = {
                    metrics = [
                        ["AWS/ECS", "CPUUtilization", "ClusterName", aws_ecs_cluster.ecs_cluster.name]
                    ]
                    period = 300
                    stat   = "Average"
                    region = var.aws_region
                    title  = "ECS CPU Utilization"
                }
            },
            {
                type = "metric"
                x    = 12
                y    = 0
                width = 12
                height = 6
                properties = {
                    metrics = [
                        ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", aws_db_instance.rds.id]
                    ]
                    period = 300
                    stat   = "Average"
                    region = var.aws_region
                    title  = "RDS CPU Utilization"
                }
            },
            {
                type = "metric"
                x    = 0
                y    = 6
                width = 12
                height = 6
                properties = {
                    metrics = [
                        ["AWS/Lambda", "Invocations", "FunctionName", var.lambda_function_name],
                        ["AWS/Lambda", "Errors", "FunctionName", var.lambda_function_name]
                    ]
                    period = 300
                    stat   = "Sum"
                    region = var.aws_region
                    title  = "Lambda Invocations & Errors"
                }
            },
            {
                type = "metric"
                x    = 12
                y    = 6
                width = 12
                height = 6
                properties = {
                    metrics = [
                        ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", aws_lb.alb.name],
                        ["AWS/ApplicationELB", "HTTPCode_Target_5XX_Count", "LoadBalancer", aws_lb.alb.name]
                    ]
                    period = 300
                    stat   = "Sum"
                    region = var.aws_region
                    title  = "ALB Requests & Errors"
                }
            }
        ]
    })
} 