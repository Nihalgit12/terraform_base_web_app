#aws_elb_service_account

data "aws_elb_service_account" "root" {}

#aws_lb

resource "aws_lb" "test-alb" {
  name               = "${local.naming_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = module.vpc.public_subnets
  depends_on = [ module.web-app-s3 ]

  enable_deletion_protection = false

  access_logs {
    bucket  = module.web-app-s3.web_bucket.id
    prefix  = "alb-logs"
    enabled = true
  }

  tags = local.common_tags
}

#aws_target_group

resource "aws_lb_target_group" "test" {
  name     = "${local.naming_prefix}-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

#lb_listener

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}

#aws_target_group_attachment

resource "aws_lb_target_group_attachment" "test" {
  count = var.instance_count[terraform.workspace]
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.nginx[count.index].id
  port             = 80
}

