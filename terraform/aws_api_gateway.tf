resource "aws_apigatewayv2_api" "hono_lambda_api" {
  name          = "${var.env}-hono-lambda-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "hono_lambda_integration" {
  api_id           = aws_apigatewayv2_api.hono_lambda_api.id
  integration_type = "AWS_PROXY"

  connection_type           = "INTERNET"
  description               = "Lambda integration for Hono Lambda"
  integration_method        = "POST"
  integration_uri           = aws_lambda_function.hono_lambda.invoke_arn
  payload_format_version    = "2.0"
}

resource "aws_apigatewayv2_route" "hono_lambda_route" {
  api_id    = aws_apigatewayv2_api.hono_lambda_api.id
  route_key = "ANY /{proxy+}"

  target = "integrations/${aws_apigatewayv2_integration.hono_lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "hono_lambda_stage" {
  api_id = aws_apigatewayv2_api.hono_lambda_api.id
  name   = "$default" # Use default stage for simplicity

  auto_deploy = true
}

resource "aws_cloudwatch_log_group" "api_gateway_logs" {
  name              = "/aws/apigateway/${var.env}-hono-lambda-api"
  retention_in_days = 7
}

resource "aws_lambda_permission" "hono_lambda_api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hono_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.hono_lambda_api.execution_arn}/*/*"
}
