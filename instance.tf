data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"

}

resource "aws_instance" "nginx" {
  count = var.instance_count[terraform.workspace]
  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.instance_type
  subnet_id              = module.vpc.public_subnets[(count.index % var.subnet_count[terraform.workspace])]
  vpc_security_group_ids = [aws_security_group.sg1.id]
  iam_instance_profile   = aws_iam_instance_profile.nginx_profile.name
  depends_on             = [module.web-app-s3]

  user_data = templatefile("${path.module}/start_up.tpl", {
    s3_bucket_name = module.web-app-s3.web_bucket.id
    }) 

  tags = merge(local.common_tags, {
    Name = "${local.naming_prefix}-nginx-${count.index}"
  }
  )
}
#aws_iam_role

resource "aws_iam_role" "allow_nginx_s3" {
  name = "${local.naming_prefix}-allow_nginx_s3"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = merge(local.common_tags, {
    Name = "${local.naming_prefix}-nginx"
  })

}

#aws_iam_role_policy

resource "aws_iam_role_policy" "allow_s3_all" {
  name = "allow_s3_all"
  role = aws_iam_role.allow_nginx_s3.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect = "Allow"
        Resource : [
          "arn:aws:s3:::${local.s3_bucket_name}",
          "arn:aws:s3:::${local.s3_bucket_name}/*"
        ]
      },
    ]
  })
}

#aws_instance_profile

resource "aws_iam_instance_profile" "nginx_profile" {
  name = "${local.naming_prefix}-nginx_profile"
  role = aws_iam_role.allow_nginx_s3.name

  
}