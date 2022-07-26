
output "terraform-state-bucket" {
  value = module.terraform_state_buckets.s3_bucket
}

output "terraform-dynamodb-table" {
  value = module.terraform_state_lock_db.dynamodb_data
}