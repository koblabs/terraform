################################
# Output Setup
################################

output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_arn" {
  value = aws_vpc.main.arn
}

# output "private_ip" {
#   value = aws_subnet.private.*.private_ip
# }

output "s3_bucket_arn" {
  value = module.s3_bucket_for_logs.s3_bucket_arn
}
