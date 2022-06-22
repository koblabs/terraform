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

  backend "consul" {
    
  }
}


####################################
# Providers
####################################

provider "aws" {
  # Configuration options
  profile = var.aws_profile
  region  = var.aws_region
}
