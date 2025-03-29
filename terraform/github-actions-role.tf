data "aws_iam_openid_connect_provider" "github_oidc" {
    url = "https://token.actions.githubusercontent.com"
}

# Importar el rol existente si existe
data "aws_iam_role" "existing_github_actions" {
    name = "GHActionsRole"
}

# Solo crear el rol si no existe
resource "aws_iam_role" "github_actions" {
    count = data.aws_iam_role.existing_github_actions == null ? 1 : 0
    
    name = "GHActionsRole"
    
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Federated = data.aws_iam_openid_connect_provider.github_oidc.arn
                }
                Action = "sts:AssumeRoleWithWebIdentity"
                Condition = {
                    StringLike = {
                        "token.actions.githubusercontent.com:sub": "repo:${var.github_repo}:*"
                    }
                    StringEquals = {
                        "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                    }
                }
            }
        ]
    })

    lifecycle {
        prevent_destroy = true
        ignore_changes = [assume_role_policy]
    }
}

# Política para el rol (se aplicará tanto al rol existente como al nuevo)
resource "aws_iam_role_policy" "github_actions_policy" {
    name = "github-actions-policy"
    role = try(aws_iam_role.github_actions[0].id, data.aws_iam_role.existing_github_actions.id)

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "ecs:*",
                    "ecr:*",
                    "lambda:*",
                    "rds:*",
                    "events:*",
                    "cloudwatch:*",
                    "logs:*",
                    "iam:*",
                    "ec2:*",
                    "elasticloadbalancing:*",
                    "sts:GetCallerIdentity"
                ]
                Resource = "*"
            }
        ]
    })

    lifecycle {
        create_before_destroy = true
    }
}

# Crear el proveedor OIDC si no existe
resource "aws_iam_openid_connect_provider" "github_actions" {
    count = data.aws_iam_openid_connect_provider.github_oidc.arn != null ? 0 : 1
    
    url = "https://token.actions.githubusercontent.com"
    
    client_id_list = [
        "sts.amazonaws.com"
    ]
    
    thumbprint_list = [
        "6938fd4d98bab03faadb97b34396831e3780aea1"  # GitHub's thumbprint
    ]

    lifecycle {
        prevent_destroy = true
    }
} 