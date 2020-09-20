variable "lambda_function_name" {
  type = string
  default = "ServerlessApplication"
}

variable "lambda_s3_bucket" {
  type = string
  default = "fokion-lambda-tests"
}

variable "lambda_s3_key" {
  type = string
  default = "server.zip"
}

variable "lambda_handler" {
  type = string
  default = "server.handler"
}

variable "tags" {
  type = map(any)
  default = {}
}
variable "env_vars" {
  type = map(any)
  default = {}
}
