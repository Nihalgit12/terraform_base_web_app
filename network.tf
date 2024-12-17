data "aws_availability_zones" "available" {
  state = "available"
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.16.0"

  name = "${local.naming_prefix}-my-vpc"
  cidr = var.cidr_block[terraform.workspace]

  azs             = slice(data.aws_availability_zones.available.names, 0, var.subnet_count[terraform.workspace])
  public_subnets  = [for subnet in range(var.subnet_count[terraform.workspace]): cidrsubnet(var.cidr_block[terraform.workspace], 8, subnet)]

  enable_nat_gateway = false
  enable_vpn_gateway = false
  map_public_ip_on_launch = var.map_public_ip_on_launch
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = local.common_tags
}

resource "aws_security_group" "sg1" {
  name   = "${local.naming_prefix}-terratest"
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    cidr_blocks = [var.cidr_block[terraform.workspace]]
    protocol    = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags

}

resource "aws_security_group" "alb" {
  name   = "albsg"
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags

}


