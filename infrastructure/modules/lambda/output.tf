
output "aws_lambda_function_name" {
  value = aws_lambda_function.default.function_name
}

output "log_path" {
  value = aws_cloudwatch_log_group.log.name
}

output "lambda_arn" {
  value = aws_lambda_function.default.arn
}

output "lambda_invoke_arn" {
  value = aws_lambda_function.default.invoke_arn
}