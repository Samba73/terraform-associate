data "aws_caller_identity" "parent" {
  provider = aws.root
}

data "aws_caller_identity" "child" {
  provider = aws.oa
}