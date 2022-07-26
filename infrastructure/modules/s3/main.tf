
locals {
  environment = var.environment != "" ? var.environment : "dev"
  prevent_destroy = var.prevent_destroy
  purpose = var.purpose
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "default" {
  bucket = join("-", [local.purpose, data.aws_caller_identity.current.account_id, local.environment])
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_versioning" "default" {
  bucket = aws_s3_bucket.default.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "default" {
  bucket = aws_s3_bucket.default.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.default.id
  rule {
    apply_server_side_encryption_by_default{
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.default.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}