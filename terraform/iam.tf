resource "aws_iam_role" "github_actions_role" {
    name = "GHActionsRole"
    
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
                }
                Action = "sts:AssumeRoleWithWebIdentity"
                Condition = {
                    StringLike = {
                        "token.actions.githubusercontent.com:sub": "repo:${var.github_repo}:*"
                    }
                }
            }
        ]
    })
}

resource "aws_iam_role_policy" "github_actions_policy" {
    name = "github-actions-policy"
    role = aws_iam_role.github_actions_role.id

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
                    "elasticloadbalancing:*"
                ]
                Resource = "*"
            }
        ]
    })
} 