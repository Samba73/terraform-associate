terraform {
  backend "s3" {
    key = "tf-tfstate"

  }
}

resource "aws_s3_bucket" "samplebucket" {
  bucket = "samba-tf-test-sample-07nov2023"

}

output "bucketname" {
  value = aws_s3_bucket.samplebucket.bucket_domain_name
}
