terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}




resource "aws_lambda_function" "lambda_app" {
  function_name = "ServerlessExample"

  # The bucket name as created earlier with "aws s3api create-bucket"
  s3_bucket = "fokion-lambda-tests"
  s3_key = "server.zip"
  handler = "server.handler"
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


resource "aws_apigatewayv2_api" "api_gateway" {
  name        = "ServerlessExample"
  description = "Terraform Serverless Application Example"
  protocol_type = "HTTP"
}


resource "aws_apigatewayv2_route" "example" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "$default"
}


resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_app.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
}
resource "aws_apigatewayv2_deployment" "example" {
  api_id      = aws_apigatewayv2_route.example.api_id
  description = "Example deployment"

  lifecycle {
    create_before_destroy = true
  }
}
