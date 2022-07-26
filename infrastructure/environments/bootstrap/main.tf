
terraform {
  required_providers {
    aws = {
      version = "~> 4.22.0"
      source  = "hashicorp/aws"
    }
  }
}

locals {
  region = "eu-central-1"
}

provider "aws" {
  region = local.region
}


module "terraform_state_buckets" {
  source          = "../../modules/s3"
  environment     = "common"
  prevent_destroy = false
  purpose         = "terraform-state-ppro"
}


module "terraform_state_lock_db" {
  source  = "../../modules/database"
  db_name = join("-", ["terraform-state-lock-ppro", module.terraform_state_buckets.aws_acc])
  hashKey = "LockID"
}

