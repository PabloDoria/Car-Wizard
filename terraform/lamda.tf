data "aws_caller_identity" "current" {}

resource "aws_lambda_function" "lambda" {
    function_name    = var.lambda_function_name
    role             = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LambdaExecutionRole"
    filename         = "../lambda/lambda.zip"
    handler          = "lambda_function.lambda_handler"
    runtime          = "python3.8"
    timeout          = 30
}
