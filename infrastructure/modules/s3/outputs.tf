output "s3_bucket" {
  value = aws_s3_bucket.default.id
}

output "aws_acc" {
  value = data.aws_caller_identity.current.account_id
}

