################################
# VPC Setup
################################

# module "vpc" {
#   source = "terraform-aws-modules/vpc/aws"

#   name = var.vpc_name
#   cidr = var.vpc_cidr_block

#   azs = slice(data.aws_availability_zones.available.names, 0, max(var.vpc_public_subnet_count, var.vpc_private_subnet_count))

#   public_subnets  = [for s in range(var.vpc_public_subnet_count) : cidrsubnet(var.vpc_cidr_block, 8, s)]
#   private_subnets = [for s in range(var.vpc_private_subnet_count) : cidrsubnet(var.vpc_cidr_block, 8, s + var.vpc_public_subnet_count)]

#   enable_nat_gateway      = var.enable_nat_gateway
#   enable_vpn_gateway      = var.enable_vpn_gateway
#   enable_dns_hostnames    = var.enable_dns_hostnames
#   map_public_ip_on_launch = var.map_public_ip_on_launch

#   default_route_table_name = "main-rt"

#   tags = merge(local.common_tags, {
#     Name = "${local.name_tag}-vpc"
#   })
# }


resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name = "${local.name_tag}-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name_tag}-ig"
  }
}

resource "aws_subnet" "public" {
  count      = var.vpc_public_subnet_count
  cidr_block =  cidrsubnet(var.vpc_cidr_block, 8, count.index)

  vpc_id = aws_vpc.main.id

  map_public_ip_on_launch = true
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "${local.name_tag}-public-${count.index}"
  }
}

resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.main.main_route_table_id

  tags = {
    Name = "${local.name_tag}-main-rt"
  }
}


################################
# Security groups
################################

# resource "aws_security_group" "alb_sg" {
#   name        = "${local.name_tag}-alb-sg"
#   description = "Security group settings for ALB"
#   vpc_id      = module.vpc.vpc_id

#   ingress = [{
#     cidr_blocks      = ["0.0.0.0/0"]
#     description      = "Allow incoming HTTP traffic from anywhere"
#     from_port        = 80
#     ipv6_cidr_blocks = ["::/0"]
#     prefix_list_ids  = []
#     protocol         = "tcp"
#     security_groups  = []
#     self             = true
#     to_port          = 80
#   }]

#   egress = [{
#     cidr_blocks      = ["0.0.0.0/0"]
#     description      = "Allow all outbound traffic"
#     from_port        = 0
#     ipv6_cidr_blocks = ["::/0"]
#     prefix_list_ids  = []
#     protocol         = "-1"
#     security_groups  = []
#     self             = true
#     to_port          = 0
#   }]

#   tags = local.common_tags
# }

# resource "aws_security_group" "servers_sg" {
#   name        = "${local.name_tag}-servers-sg"
#   description = "Security group settings for all servers"
#   vpc_id      = module.vpc.vpc_id


#   dynamic "ingress" {
#     for_each = local.ingress
#     content {
#       cidr_blocks      = ingress.value.cidr_blocks
#       description      = ingress.value.description
#       from_port        = ingress.value.port
#       ipv6_cidr_blocks = []
#       prefix_list_ids  = []
#       protocol         = ingress.value.protocol
#       security_groups  = []
#       self             = true
#       to_port          = ingress.value.port
#     }
#   }

#   egress = [{
#     cidr_blocks      = ["0.0.0.0/0"]
#     description      = "Allow all outbound traffic"
#     from_port        = 0
#     ipv6_cidr_blocks = ["::/0"]
#     prefix_list_ids  = []
#     protocol         = "-1"
#     security_groups  = []
#     self             = true
#     to_port          = 0
#   }]

#   tags = local.common_tags
# }
