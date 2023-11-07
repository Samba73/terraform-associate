output "bucketname" {
  value = aws_s3_bucket.statebucket.bucket_domain_name
}
output "bucketarn" {
  value = aws_s3_bucket.statebucket.arn
}