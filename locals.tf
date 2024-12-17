locals {
  common_tags = {
    company      = var.company
    project      = "${var.company}-${var.project}"
    Billing_code = var.Billing_code
  }

  website_content = {
    website = "/website/index.html"
    logo = "/website/Globo_logo_Vert.png"
  }

  naming_prefix = "${var.naming_prefix}-${terraform.workspace}"

  s3_bucket_name = "${lower(local.naming_prefix)}-${random_integer.s3.result}"

  environment =  terraform.workspace
}

resource "random_integer" "s3" {
  min = 10000
  max = 99999
}