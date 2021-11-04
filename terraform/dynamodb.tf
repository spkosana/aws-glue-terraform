resource "aws_dynamodb_table" "statefile" {
  name           = var.dynamodb_table
  hash_key       = "LockID"
  read_capacity  = 8
  write_capacity = 8

  attribute  {
    name = "LockID"
    type = "S"
  }

  tags = {
    "Name" : var.tag_name
  }

  depends_on = [aws_s3_bucket.backend]

}
