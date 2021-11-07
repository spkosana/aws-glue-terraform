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


resource "aws_s3_bucket_object" "incidents" {
  bucket = "${aws_s3_bucket.backend.bucket}"
  key    = "scripts/fact_incidents_etl.py"
  source = "${path.cwd}/../scripts/fact_incidents_etl.py"
  etag   = filemd5("${path.cwd}/../scripts/fact_incidents_etl.py")
}