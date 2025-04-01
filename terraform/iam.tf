resource "aws_iam_role_policy" "lambda_s3_access" {
    name = "lambda_s3_access"
    role = aws_iam_role.lambda_role.id

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "s3:GetObject",
                    "s3:PutObject",
                    "s3:ListBucket"
                ]
                Resource = [
                    "arn:aws:s3:::${var.s3_data_bucket_name}/*",
                    "arn:aws:s3:::${var.s3_data_bucket_name}",
                    "arn:aws:s3:::car-wizard-code/*",
                    "arn:aws:s3:::car-wizard-code"
                ]
            }
        ]
    })
} 