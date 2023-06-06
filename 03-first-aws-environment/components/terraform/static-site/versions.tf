terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # Note, we are not upgrading to v5 until this issue is resolved:
      # https://github.com/cloudposse/terraform-aws-cloudfront-s3-cdn/issues/279
      version = "< 5"
    }
  }
}
