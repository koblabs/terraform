################################
# Initial reesource setup
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
# AWS region
################################

variable "aws_region" {
  type        = string
  description = "AWS resources region"
  default     = "ca-central-1"
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
  type        = string
  description = "Base CIDR block for VPC"

}

variable "vpc_subnet_count" {
  type        = number
  description = "Number of subnets in VPC"
  default     = 2
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Assign public IPV4 to subnet instances"
  default     = true
}
