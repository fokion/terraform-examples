terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}




resource "aws_lambda_function" "example" {
  function_name = "ServerlessExample"

  # The bucket name as created earlier with "aws s3api create-bucket"
  s3_bucket = "fokion-lambda-tests"

  handler = "server.js"
  runtime = "nodejs12.x"
  environment {
    variables = merge(var.env_vars,{APP_SECRET=uuid()})
  }
  role = aws_iam_role.lambda_exec.arn
}

# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "lambda_exec" {
  name = "serverless_example_lambda"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        Action: "sts:AssumeRole",
        Principal: {
          "Service": "lambda.amazonaws.com"
        },
        Effect: "Allow",
        Sid: ""
      }
    ]
  }
  )

}

