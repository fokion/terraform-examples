resource "aws_s3_bucket" "project-bucket" {
  bucket = "tf-${var.application}"
  acl = "private"

  tags = {
    Project = var.application
  }
}
resource "aws_s3_bucket_policy" "content_bucket_policy" {
  bucket = aws_s3_bucket.project-bucket.id
  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
	  "Sid":"PublicReadGetObject",
      "Effect":"Allow",
	  "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource": "${aws_s3_bucket.project-bucket.arn}/public/*"
    }
  ]
}
POLICY
}