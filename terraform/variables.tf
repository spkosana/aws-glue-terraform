variable "region" {
  type        = string
  description = "(optional) describe your variable"
  default     = "us-east-2"
}

variable "profile" {
  type        = string
  description = "(optional) describe your variable"
  default     = "terraform"
}

variable "bucket_name" {
  type        = string
  description = "(optional) describe your variable"
  default     = "sample-glue"
}

variable "tag_name" {
  type = string
  description = "(optional) describe your variable"
  default = "glue-terraform"
}

variable "dynamodb_table" {
  type = string
  description = "(optional) describe your variable"
  default = "state-glue-terraform"
}

variable "raw_bucket" {
  type = string
  description = "(optional) describe your raw bucket"
  default = "s3://raw_bucket/"
}

variable "prepared_bucket" {
  type = string
  description = "(optional) describe your raw bucket"
  default = "s3://prepared_bucket/"
}

variable "cw_log_group" {
  type = string
  description = "(optional) describe your variable"
  default = "glue-cloud-watch"
}

variable "max_capacity" {
  type = number
  description = "(optional) describe your variable"
  default = 2
}

variable "max_retries" {
  type = number
  description = "(optional) describe your variable"
  default = 1
}

variable "timeout" {
  type = number
  description = "(optional) describe your variable"
  default = 60
}

variable "glue_version" {
  type = string
  description = "(optional) describe your variable"
  default = "2.0"
}


variable "max_concurrent_runs" {
  type = number
  description = "(optional) describe your variable"
  default = 1
}

variable "incidents_schedule" {
  type = string
  description = "(optional) describe your variable"
  default = "rate(1 day)"
}

variable "incidents_trigger_type" {
  type = string
  description = "(optional) describe your variable"
  default = "SCHEDULED"
}
