resource "aws_iam_role" "role" {
  name        = "GlueETLRole"
  description = "Glue Terraform role"
  assume_role_policy = "${file("configs/glue-role.json")}"
}


resource "aws_iam_role_policy_attachment" "role-policy-attachment" {
  for_each = toset([
    "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole", 
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  ])

  role       = aws_iam_role.role.name
  policy_arn = each.value
}