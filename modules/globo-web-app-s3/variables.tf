variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket to create"
}

variable "aws_elb_service_account_arn" {
  type = string
}

variable "common_tags" {
    type = map(string)
    default = {}  
}