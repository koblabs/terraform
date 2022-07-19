################################
# Output Setup
################################

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_arn" {
  value = module.vpc.vpc_arn
}

output "private_ip" {
  value = aws_instance.server[*].private_ip
}

output "s3_bucket_arn" {
  value = module.s3_bucket_for_logs.s3_bucket_arn
}
