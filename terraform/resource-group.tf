resource "aws_resourcegroups_group" "car_wizard" {
    name = "car-wizard-resources"
    description = "Grupo de recursos para la aplicación Car Wizard"

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
    })

    tags = var.common_tags
} 