# Política específica para el proyecto Car-Wizard
resource "aws_iam_policy" "car_wizard_view" {
    name = "CarWizardViewAccess"
    description = "Política para ver recursos de Car-Wizard"

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "ecs:List*",
                    "ecs:Describe*",
                    "ecr:List*",
                    "ecr:Describe*",
                    "rds:Describe*",
                    "lambda:List*",
                    "lambda:Get*",
                    "cloudwatch:Get*",
                    "cloudwatch:List*",
                    "logs:Get*",
                    "logs:List*",
                    "logs:Describe*",
                    "ec2:Describe*",
                    "elasticloadbalancing:Describe*",
                    "resourcegroupstaggingapi:GetResources"
                ]
                Resource = "*"
                Condition = {
                    StringEquals = {
                        "aws:ResourceTag/Project": "car-wizard"
                    }
                }
            }
        ]
    })

    lifecycle {
        prevent_destroy = true
    }
}

# Grupo para los miembros del equipo
resource "aws_iam_group" "car_wizard_viewers" {
    name = "car-wizard-viewers"

    lifecycle {
        prevent_destroy = true
    }
}

# Asignar la política al grupo
resource "aws_iam_group_policy_attachment" "car_wizard_viewers_policy" {
    group      = aws_iam_group.car_wizard_viewers.name
    policy_arn = aws_iam_policy.car_wizard_view.arn

    lifecycle {
        prevent_destroy = true
    }
}

# Crear usuarios para los miembros del equipo
variable "team_members" {
    description = "Lista de nombres de los miembros del equipo"
    type        = list(string)
    default     = [
        "anad",      # Ana D
        "angelg",    # Angel G
        "luism"      # Luis M
    ]
}

data "aws_iam_user" "existing_users" {
    for_each = toset(var.team_members)
    user_name = "car-wizard-${each.value}"
}

locals {
    # Filtrar solo los usuarios que no existen
    users_to_create = {
        for member in var.team_members :
        member => member
        if can(data.aws_iam_user.existing_users[member].user_name) == false
    }
}

resource "aws_iam_user" "team_members" {
    for_each = local.users_to_create
    name     = "car-wizard-${each.value}"
    tags     = var.common_tags

    lifecycle {
        prevent_destroy = true
    }
}

# Agregar usuarios al grupo
resource "aws_iam_group_membership" "car_wizard_team" {
    name  = "car-wizard-team-membership"
    group = aws_iam_group.car_wizard_viewers.name
    users = [for user in aws_iam_user.team_members : user.name]
}

# Crear acceso a la consola para cada usuario
resource "aws_iam_user_login_profile" "team_member_login" {
    for_each = aws_iam_user.team_members
    user     = each.value.name
    
    password_reset_required = true
    password_length        = 12

    lifecycle {
        ignore_changes = [
            password_length,
            password_reset_required
        ]
        prevent_destroy = true
    }
}

# Outputs para obtener las credenciales
output "team_member_credentials" {
    value = {
        for user, login in aws_iam_user_login_profile.team_member_login : user => {
            username = aws_iam_user.team_members[user].name
            password = login.password
        }
    }
    sensitive = true
} 