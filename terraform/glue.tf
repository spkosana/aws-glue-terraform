resource "aws_glue_job" "facts_incidents" {
  name         = "incidents_etl"
  description  = "Git Project: Created using Terraform"
  role_arn     = aws_iam_role.role.arn
  max_capacity = var.max_capacity
  max_retries  = var.max_retries
  timeout      = var.timeout
  glue_version = var.glue_version

  command {
    script_location = "s3://${aws_s3_bucket.backend.bucket}/${aws_s3_bucket_object.incidents.key}"
    python_version  = "3"
  }
  default_arguments = {
    # ... potentially other arguments ...
    "--job-language"                     = "python"
    "--continuous-log-logGroup"          = "${aws_cloudwatch_log_group.this.name}"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
    "--enable-metrics"                   = ""
    "--job-bookmark-option"              = "job-bookmark-enable"
    "--enable-spark-ui"                  = "true"
    "--SOURCE_S3_LOCATION"               = var.raw_bucket
    "--DESTINATION_S3_LOCATION"          = var.prepared_bucket
  }
  execution_property {
    max_concurrent_runs = var.max_concurrent_runs
  }

  tags = {
    Name = var.tag_name
  }

  depends_on = [aws_s3_bucket_object.incidents]
}


resource "aws_glue_trigger" "incidents" {
  name     = "fact_incidents_etl"
  description = "Incidents merge small parquet files to optimum size parquet"
  schedule = var.incidents_schedule
  type     = var.incidents_trigger_type

  actions {
    job_name = aws_glue_job.facts_incidents.name
  }

  tags = {
    Name = var.tag_name
  }

  depends_on = [aws_glue_job.facts_incidents]

}