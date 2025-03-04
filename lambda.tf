resource "aws_lambda_function" "serverless_api_function" {
  function_name     = "serverless_api_function"
  role              = "arn:aws:iam::432575282858:role/LambdaBasicExecution"
  handler           = "lambda_function.lambda_handler"
  runtime           = "python3.13"
  filename          = "lambda_function.zip"
  source_code_hash  = filebase64sha256("lambda_function.zip")
}