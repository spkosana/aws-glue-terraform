resource "aws_cloudwatch_log_group" "this" {
  name              = "aws-glue-etl"
  retention_in_days = 14
  tags = {
    Name = var.tag_name
  }
}