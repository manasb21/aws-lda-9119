variable "lambda_name" {
  type = string
}
variable "lambda_handler" {
  type = string
}
variable "region" {
  type = string
  validation {
    condition = contains(["eu-central-1", "eu-west-3"], var.region)
    error_message = "Regions except eu-central-1 and eu-west-3 are not allowed"
  }
}
variable "memory_size" {
  type = number
  default = 1024
}
variable "environment" {
  type = string
}

variable "table_name" {}