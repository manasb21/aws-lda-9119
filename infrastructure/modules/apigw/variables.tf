variable "api_gw_name" {
  type = string
  default = ""
}
variable "aws_lambda_arn" {
  type = string
  description = "AWS Lambda ARN can be received from the lambda module"
}
variable "environment" {
  type = string
  description = "Environment name of deployment"
}
variable "aws_lambda_function_name" {
  type = string
  description = "AWS Lambda function name can be received from the lambda module"
}
variable "region" {
  type = string
  validation {
    condition = contains(["eu-central-1", "eu-west-3"], var.region)
    error_message = "Regions except eu-central-1 and eu-west-3 are not allowed"
  }
}

variable "context_root" {
  type = string
  validation {
    condition = !can(regex("/", var.context_root))
    error_message = "The context root can not have / in the string"
  }
}