terraform {
  required_version = "~> 0.13"
}

locals {
  aws_region = "eu-west-1"
}

provider "aws" {
  region = local.aws_region
}

resource "aws_route53_zone" "main" {
  name = "fokion.xyz"
}