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