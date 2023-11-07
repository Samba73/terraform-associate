resource "aws_dynamodb_table" "tfstate" {
  name = var.tablename
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}