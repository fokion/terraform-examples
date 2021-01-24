terraform {

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.25.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.0.1"
    }
    null = {
      source = "hashicorp/null"
      version = "3.0.0"
    }
  }
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



resource "aws_route53_record" "nas" {
  name = "nas.fokion.xyz"
  type = "A"
  ttl = 3600
  records = [
    var.homeip
  ]
}