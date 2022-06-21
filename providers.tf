####################################
# Terraform config
####################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.19.0"
    }
  }
}


####################################
# Providers
####################################

provider "aws" {
  # Configuration options
  region = var.aws_region
}
