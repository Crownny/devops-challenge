
terraform {
  required_version = ">= 1.12.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  # Plumbing so `terraform plan` can run against fake credentials without
  # calling AWS. Remove these three lines for a real deployment.
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_region_validation      = true
}

