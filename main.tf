terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}



resource "aws_route53_zone" "main" {
  name = "fokion.xyz"
}