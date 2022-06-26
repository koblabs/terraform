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
}
