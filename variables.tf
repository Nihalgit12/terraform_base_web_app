variable "aws_access_key" {
  type        = string
  description = "aws_access_key"
  sensitive   = true
}

variable "secret_access_key" {
  type      = string
  sensitive = true
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "cidr_block" {
  type    = map(string)
  
}

variable "subnets_cidr_block" {
  type    = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "subnet_count" {
  type = map(any)
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "map_public_ip_on_launch" {
  type    = bool
  default = true
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "instance_count" {
  type = map(any)
}

variable "company" {
  type    = string
  default = "Globomantics"
}

variable "project" {
  type = string
}

variable "Billing_code" {
  type = string
}

variable "naming_prefix" {
  type        = string
  description = "Naming prefix for all resources."
  default     = "globo-web-app"
}

variable "environment" {
  type        = string
  description = "Environment for deployment"
  default     = "development"
}
