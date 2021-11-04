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