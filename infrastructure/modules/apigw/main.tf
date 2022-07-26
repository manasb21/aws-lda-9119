
locals {
  api_gw_name              = var.api_gw_name != "" ? var.api_gw_name : "ppro-api-gw-${local.environment}"
  aws_lambda_arn           = var.aws_lambda_arn
  environment              = try(var.environment, "dev")
  aws_lambda_function_name = var.aws_lambda_function_name
  region = var.region
  api_gw_protocol = "HTTP"
  context_root = var.context_root
}

/*
New api gateway
*/

resource "aws_apigatewayv2_api" "lambda-default" {
  name          = local.api_gw_name
  protocol_type = local.api_gw_protocol
}

resource "aws_apigatewayv2_stage" "lambda-default" {
  depends_on = [aws_cloudwatch_log_group.api-gw]
  api_id = aws_apigatewayv2_api.lambda-default.id
  name   = join("-", [local.api_gw_name, "stage", local.environment])
  auto_deploy = true
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api-gw.arn
    format          = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
    })
  }
}




resource "aws_cloudwatch_log_group" "api-gw" {
  name = "/aws/api-gw/${aws_apigatewayv2_api.lambda-default.name}"
  retention_in_days = 30
}

resource "aws_apigatewayv2_integration" "hello" {
  api_id           = aws_apigatewayv2_api.lambda-default.id
  integration_uri = local.aws_lambda_arn
  integration_type = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "hello_world" {
  api_id = aws_apigatewayv2_api.lambda-default.id

  route_key = "GET /${local.context_root}"
  target    = "integrations/${aws_apigatewayv2_integration.hello.id}"
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = local.aws_lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda-default.execution_arn}/*/*"
}