################################
# VPC Setup
################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr_block

  azs = slice(data.aws_availability_zones.available.names, 0, var.vpc_subnet_count)

  # private_subnets = []
  public_subnets = [for s in range(var.vpc_subnet_count) : cidrsubnet(var.vpc_cidr_block, 8, s)]

  enable_nat_gateway      = var.enable_nat_gateway
  enable_vpn_gateway      = var.enable_vpn_gateway
  enable_dns_hostnames    = var.enable_dns_hostnames
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(local.common_tags, {
    Name = "${local.name_tag}-vpc"
  })
}


################################
# Security groups
################################

resource "aws_security_group" "alb_sg" {
  name        = "${local.name_tag}-alb-sg"
  description = "Security group settings for ALB"
  vpc_id      = module.vpc.vpc_id

  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Allow incoming HTTP traffic from anywhere"
    from_port        = 80
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = true
    to_port          = 80
  }]

  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Allow all outbound traffic"
    from_port        = 0
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = true
    to_port          = 0
  }]

  tags = local.common_tags
}

resource "aws_security_group" "servers_sg" {
  name        = "${local.name_tag}-servers-sg"
  description = "Security group settings for all servers"
  vpc_id      = module.vpc.vpc_id

  ingress = [{
    cidr_blocks      = [var.vpc_cidr_block]
    description      = "Allow incoming HTTP traffic from specified cidr blocks"
    from_port        = 80
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = true
    to_port          = 80
    }, {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Allow incoming SSH traffic from anywhere"
    from_port        = 22
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = true
    to_port          = 22
  }]

  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Allow all outbound traffic"
    from_port        = 0
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = true
    to_port          = 0
  }]

  tags = local.common_tags
}
