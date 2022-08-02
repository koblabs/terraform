################################
# VPC Setup
################################

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
  cidr_block = cidrsubnet(var.vpc_cidr_block, 8, count.index)

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

resource "aws_route" "public" {
  count                  = var.vpc_public_subnet_count
  route_table_id         = aws_default_route_table.main.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  count          = var.vpc_public_subnet_count
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_default_route_table.main.id
}

resource "aws_subnet" "private" {
  count      = var.vpc_private_subnet_count
  cidr_block = cidrsubnet(var.vpc_cidr_block, 8, count.index + var.vpc_public_subnet_count)

  vpc_id = aws_vpc.main.id

  map_public_ip_on_launch = true
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "${local.name_tag}-private-${count.index}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name_tag}-private-rt"
  }
}

resource "aws_route_table_association" "private" {
  count          = var.vpc_private_subnet_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}


################################
# Network ACLs
################################

resource "aws_network_acl" "public" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.public.*.id

  tags = merge(local.common_tags, {
    Name = "${local.name_tag}-public-nacl"
  })
}

resource "aws_network_acl" "private" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.private.*.id

  tags = merge(local.common_tags, {
    Name = "${local.name_tag}-private-nacl"
  })
}

resource "aws_network_acl_rule" "public_nacl_ingress_1" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 200
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "public_nacl_egress_1" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 200
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "private_nacl_ingress_1" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 200
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "private_nacl_egress_1" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 200
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}


################################
# Security groups
################################

resource "aws_security_group" "alb_sg" {
  name        = "${local.name_tag}-alb-sg"
  description = "Security group settings for ALB"

  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${local.name_tag}-alb-sg"
  })
}

resource "aws_security_group" "servers_sg" {
  name        = "${local.name_tag}-servers-sg"
  description = "Security group settings for all servers"

  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${local.name_tag}-servers-sg"
  })
}

resource "aws_security_group_rule" "alb_sg_ingress_1" {
  type              = "ingress"
  to_port           = 80
  protocol          = "tcp"
  from_port         = 80
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "alb_sg_egress_1" {
  type                     = "egress"
  to_port                  = 80
  protocol                 = "tcp"
  from_port                = 80
  source_security_group_id = aws_security_group.servers_sg.id
  security_group_id        = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "servers_sg_ingress_1" {
  type                     = "ingress"
  to_port                  = 80
  protocol                 = "tcp"
  from_port                = 80
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id        = aws_security_group.servers_sg.id
}

resource "aws_security_group_rule" "servers_sg_ingress_2" {
  type                     = "ingress"
  to_port                  = 0
  protocol                 = "-1"
  from_port                = 0
  source_security_group_id = aws_security_group.servers_sg.id
  security_group_id        = aws_security_group.servers_sg.id
}

resource "aws_security_group_rule" "servers_sg_egress_1" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.servers_sg.id
}
