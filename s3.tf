
module "web-app-s3" {
  source = "./modules/globo-web-app-s3"

  bucket_name = local.s3_bucket_name
  aws_elb_service_account_arn = data.aws_elb_service_account.root.arn
  common_tags = local.common_tags
}

resource "aws_s3_object" "website_content" {
  bucket = module.web-app-s3.web_bucket.id

  for_each = local.website_content
  key    = each.value
  source = "${path.root}/${each.value}"

  tags = local.common_tags

}

