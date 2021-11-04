terraform {
  backend "s3" {
    bucket         = "aws-glue-terraform-state-kspr"
    key            = "glue-terraform/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "glue-terraform-state"
  }
}
