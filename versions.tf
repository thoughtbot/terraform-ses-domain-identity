terraform {
  required_version = ">= 0.14.0"
  required_providers {
    aws = {
      configuration_aliases = [aws.identity, aws.route53]
      source                = "hashicorp/aws"
      version               = "~> 5.0"
    }
  }
}
