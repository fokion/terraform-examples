terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}




resource "aws_lambda_function" "lambda_app" {
  function_name = var.lambda_function_name
  s3_bucket = var.lambda_s3_bucket
  s3_key = var.lambda_s3_key
  handler = var.lambda_handler
  timeout = 30
  description = "${var.lambda_function_name} λ"
  runtime = "nodejs12.x"
  environment {
    variables = merge(var.env_vars,{APP_SECRET=uuid()})
  }
  tags = var.tags
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
resource "random_id" "server" {
  byte_length = 8
}

resource "aws_apigatewayv2_api" "api_gateway" {
  name        = "ServerlessExample-${random_id.server.hex}"
  description = "Terraform Serverless Application Example"
  protocol_type = "HTTP"
  target        = aws_lambda_function.lambda_app.arn
}


resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_app.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
}
