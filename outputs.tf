################################
# Output Setup
################################

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_arn" {
  value = module.vpc.vpc_arn
}

output "public_ip" {
  value = aws_instance.server[*].public_ip
}

output "s3_bucket_arn" {
  value = module.s3_bucket.s3_bucket_arn
}
