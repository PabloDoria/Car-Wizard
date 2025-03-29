data "aws_iam_openid_connect_provider" "github_oidc" {
    url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_role" "github_actions" {
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

    # Importante: No permitir que Terraform destruya este rol
    lifecycle {
        prevent_destroy = true
    }
}

resource "aws_iam_role_policy" "github_actions_policy" {
    name = "github-actions-policy"
    role = aws_iam_role.github_actions.id

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

    # Importante: No permitir que Terraform destruya esta política
    lifecycle {
        prevent_destroy = true
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

    # Importante: No permitir que Terraform destruya este proveedor
    lifecycle {
        prevent_destroy = true
    }
} 