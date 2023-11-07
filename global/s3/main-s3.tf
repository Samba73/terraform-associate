resource "aws_s3_bucket" "statebucket" {
    bucket = var.bucketname
}

resource "aws_s3_bucket_versioning"   "versioning" {
    bucket = aws_s3_bucket.statebucket.id
    versioning_configuration {
      status = "Enabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.statebucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "publicaccess" {
  bucket = aws_s3_bucket.statebucket.id
  block_public_policy = true
  block_public_acls = true
  ignore_public_acls = true
  restrict_public_buckets = true
}


