
locals {
  name       = try(var.lambda_name, "ppro-lambda-${local.environment}")
  handler    = var.lambda_handler
  account_id = data.aws_caller_identity.current.account_id
  region     = try(var.region, "eu-central-1")
  memory_size = var.memory_size
  environment = var.environment
  table_name = var.table_name
  source_file = "../../../../application/bin/hello"
}


data "aws_caller_identity" "current" {}



data "archive_file" "lambdaArchive" {
  source_file = local.source_file
  type        = "zip"
  output_path = "bin/hello.zip"
}

data "aws_iam_policy_document" "assume_role" {
  policy_id = join("-", [local.name, "lambda", local.environment])
  version   = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name               = join("-", [local.name, "lambda", local.environment])
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "db_lambda_policy" {
  name = "db_lambda_policy"
  role = aws_iam_role.lambda.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:BatchGetItem",
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan",
        ],
        Resource = "arn:aws:dynamodb:${local.region}:${local.account_id}:table/*"
      }
    ]
  })
}

data "aws_iam_policy_document" "logs" {
  policy_id = "${local.name}-${local.environment}-lambda-logs"
  version   = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["logs:CreateLogStream", "logs:PutLogEvents"]

    resources = ["arn:aws:logs:*:*:log-group:/aws/lambda/*"]
  }
}

resource "aws_iam_policy" "logs" {
  name   = join("-", [local.name, "lambda", "logs",local.environment])
  policy = data.aws_iam_policy_document.logs.json
}

resource "aws_iam_role_policy_attachment" "logs" {
  policy_arn = aws_iam_policy.logs.arn
  role       = aws_iam_role.lambda.name
  depends_on = [aws_iam_role.lambda, aws_iam_policy.logs]
}

resource "aws_cloudwatch_log_group" "log" {
  name              = "/aws/lambda/${local.name}/${local.environment}"
  retention_in_days = 7
}

resource "aws_lambda_function" "default" {
  depends_on = [data.archive_file.lambdaArchive]
  function_name = local.name
  role          = aws_iam_role.lambda.arn
  handler = local.handler
  source_code_hash = data.archive_file.lambdaArchive.output_base64sha256
  filename = data.archive_file.lambdaArchive.output_path
  runtime           = "go1.x"
  memory_size = local.memory_size
  timeout = 30
  environment {
    variables = {
      ENVIRONMENT = local.environment
      TABLE_NAME = local.table_name
      REGION = local.region
    }
  }
}