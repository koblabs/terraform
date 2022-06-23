################################
# Terraform config
################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.19.0"
    }
  }
}


################################
# Providers
################################

provider "aws" {
  # Configuration options
  profile = var.aws_profile
  region  = var.aws_region
}

provider "consul" {
  address    = "${var.consul_address}:${var.consul_port}"
  datacenter = var.consul_datacenter
}
