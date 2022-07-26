
locals {
  environment = var.environment
  handler = try(var.handler, "hello-world")
  database_name = join("-", [var.db_name, local.environment])
}

data "aws_caller_identity" "current" {}

module "ppro-lambda" {
  depends_on = [module.ppro-dynamodb]
  source = "../../../modules/lambda"
  environment = terraform.workspace
  lambda_handler = local.handler
  region = basename(path.cwd)
  lambda_name = "ppro-lambda-${terraform.workspace}"
  table_name = module.ppro-dynamodb.dynamodb_data
}

output "lambda_arn" {
  value = module.ppro-lambda.lambda_arn
}

module "ppro-api-gw" {
  depends_on = [module.ppro-lambda]
  source = "../../../modules/apigw"
  aws_lambda_arn = module.ppro-lambda.lambda_invoke_arn
  aws_lambda_function_name = module.ppro-lambda.aws_lambda_function_name
  environment = terraform.workspace
  region = basename(path.cwd)
  context_root = var.context_root
}

module "ppro-dynamodb" {
  source = "../../../modules/database"
  db_name = local.database_name
  hashKey = "env"
}