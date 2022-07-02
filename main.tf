################################
# Instances
################################

resource "aws_instance" "server" {
  count                  = var.instance_count
  ami                    = data.aws_ami.ami.id
  instance_type          = var.instance_type
  subnet_id              = module.vpc.public_subnets[(count.index % var.vpc_subnet_count)]
  vpc_security_group_ids = [aws_security_group.servers_sg.id]
  # iam_instance_profile   = module.web_app_s3.instance_profile.name
  # depends_on             = [module.web_app_s3]

  # user_data = templatefile("${path.module}/startup_script.tpl", {
  #   s3_bucket_name = module.web_app_s3.web_bucket.id
  # })

  tags = merge(local.common_tags, {
    Name = "${local.name_tag}-server-${count.index}"
  })
}


################################
# Load balancer
################################

resource "aws_lb" "nginx" {
  name               = "${local.name_tag}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false

  # access_logs {
  #   bucket  = module.s3_buckets.web_bucket.id
  #   prefix  = "alb-logs"
  #   enabled = true
  # }

  tags = local.common_tags
}

resource "aws_lb_target_group" "nginx" {
  name     = "${local.name_tag}-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_lb_listener" "nginx" {
  load_balancer_arn = aws_lb.nginx.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }

  tags = local.common_tags
}

resource "aws_lb_target_group_attachment" "nginx" {
  count            = var.instance_count
  target_group_arn = aws_lb_target_group.nginx.arn
  target_id        = aws_instance.server[count.index].id
  port             = 80
}


################################
# S3 Bucket
################################

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = join("-", ["koblabs", uuid()])
  acl    = "private"

  versioning = {
    enabled = true
  }

  tags = local.common_tags
}
