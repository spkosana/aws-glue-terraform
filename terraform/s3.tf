resource "aws_s3_bucket" "backend" {
  bucket = var.bucket_name
  acl    = "private"
  versioning {
    enabled = true
  }
  tags = {
    "Name" : var.tag_name
  }
}