locals {
    common-tags = {
        comapny = var.comapny
        billing_code = var.billing_code
        environment = terraform.workspace
        project ="${var.company}-${var.project}-${terraform.workspace}"
    }

    name_tag = "${var.naming_prefix}-${terraform.workspace}"
}
