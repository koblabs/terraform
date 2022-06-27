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

  ingress = [{
    cidr_blocks = [var.vpc_cidr_block]
    description = "Allow incoming HTTP traffic from specified cidr blocks"
    port        = 80
    protocol    = "tcp"
    }, {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming SSH traffic from anywhere"
    port        = 22
    protocol    = "tcp"
  }]
}
