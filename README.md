# Terraform Serverless API - Tutorial Script

### Step 1: Set Up Terraform Project Structure

1. Create initial files with the following directory structure:

```
terraform_serverless_api/
│── lambda/                 # Folder for Lambda function code
│   ├── lambda_function.py  # Sample Lambda function
|── apigateway.tf           # Creates API Gateway
|── dynamodb.tf             # Creates DynamoDB table
|── lambda.tf               # Deploys AWS Lambda
│── main.tf                 # Main Terraform file
│── outputs.tf              # Outputs after deployment
|── provider.tf             # AWS provider config
|── variables.tf            # Stores variable definitions
```

---

### Step 2: Configure Terraform

1. Modify `provider.tf` to configure AWS provider:

```hcl
provider "aws" {
  region = "<aws-region>"
}
```

2. Modify `dynamodb.tf` to provision NoSQL database:

```hcl
resource "aws_dynamodb_table" "serverless_api_table" {
  name          = "serverless_api_table"
  billing_mode  = "PAY_PER_REQUEST"
  hash_key      = "id"

  # define table attributes (S = string, N = number, B = binary)
  attribute {
    name = "id"
    type = "S"
  }
}
```

3. Modify `lambda.tf` to provision Lambda function:

```hcl
resource "aws_lambda_function" "serverless_api_function" {
  function_name     = "serverless_api_function"
  role              = "arn:aws:iam::<aws-account-id>:role/<aws-iam-role>"
  handler           = "lambda_function.lambda_handler"
  runtime           = "python3.13"
  filename          = "lambda_function.zip"
  source_code_hash  = filebase64sha256("lambda_function.zip")
}
```

4. Modify `apigateway.tf` to expose Lambda function via REST API:

```hcl
resource "aws_api_gateway_rest_api" "api" {
  name = "serverless_api"
}

resource "aws_api_gateway_resource" "resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "items"
}

resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.serverless_api_function.invoke_arn
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [ aws_api_gateway_integration.lambda_integration ]
  rest_api_id = aws_api_gateway_rest_api.api.id
}
```
