
locals {
  name = var.db_name
  read = 10
  write = 10
  hashKey = var.hashKey
}


resource "aws_dynamodb_table" "default" {
  name = local.name
  read_capacity = local.read
  write_capacity = local.write
  hash_key = local.hashKey
  attribute {
    name = local.hashKey
    type = "S"
  }
}

