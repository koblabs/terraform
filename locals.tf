################################
# Local setup
################################

locals {
  common_tags = {
    terraform    = "true"
    company      = var.company
    billing_code = var.billing_code
    environment  = terraform.workspace
    project      = "${var.company}-${var.project}-${terraform.workspace}"
  }

  name_tag = "${var.naming_prefix}-${terraform.workspace}"

  vpc_cidr_block   = var.vpc_cidr_block[terraform.workspace]
  vpc_subnet_count = var.vpc_subnet_count[terraform.workspace]

  instance_type  = var.instance_type[terraform.workspace]
  instance_count = var.instance_count[terraform.workspace]
}
