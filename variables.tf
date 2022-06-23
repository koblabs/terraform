################################
# Initial resource setup
################################

variable "naming_prefix" {
  type        = string
  description = "Naming prefix for resources tagging"
  default     = "koblabs"
}

variable "company" {
  type        = string
  description = "Company name for resource tagging"
  default     = "Koblabs"
}

variable "project" {
  type        = string
  description = "Project name for resource tagging"
  default     = "Terraform"
}

variable "billing_code" {
  type        = string
  description = "Billing code for resource tagging"
}


################################
# AWS setup
################################

variable "aws_region" {
  type        = string
  description = "AWS resources region"
  default     = "ca-central-1"
}

variable "aws_profile" {
  type        = string
  description = "AWS profile for credentials"
  default     = "terraform"
}


################################
# Consul setup
################################

variable "consul_address" {
  type        = string
  description = "Address of Consul server"
  default     = "127.0.0.1"
}

variable "consul_port" {
  type        = number
  description = "Port on which Consul server is listening on"
  default     = "8500"
}

variable "consul_datacenter" {
  type        = string
  description = "Name of the Consul datacenter"
  default     = "dc1"
}


################################
# VPC setup
################################

variable "enable_nat_gateway" {
  type        = bool
  description = "Enable NAT gateway in VPC"
  default     = false
}

variable "enable_vpn_gateway" {
  type        = bool
  description = "Enable VPN gateway in VPC"
  default     = false
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in VPC"
  default     = true
}

variable "vpc_name" {
  type        = string
  description = "VPC name"
  default     = "my-vpc"
}

variable "vpc_cidr_block" {
  type        = map(string)
  description = "Base CIDR block for VPC"
}

variable "vpc_subnet_count" {
  type        = map(number)
  description = "Number of subnets in VPC"
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Assign public IPV4 to subnet instances"
  default     = true
}


################################
# Instance setup
################################

variable "instance_count" {
  type        = map(number)
  description = "Number of EC2 instances to create in VPC"
}

variable "instance_type" {
  type        = map(string)
  description = "EC2 instance type"
}
