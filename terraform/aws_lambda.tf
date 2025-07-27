data "archive_file" "hono_lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../dist/index.js"
  output_path = "${path.module}/.terraform/hono_lambda.zip"
}

resource "aws_lambda_function" "hono_lambda" {
  function_name = "${var.env}-hono-lambda"
  runtime      = "nodejs22.x"
  handler     = "index.handler"
  role       = aws_iam_role.hono_lambda_exec.arn
  filename     = data.archive_file.hono_lambda_zip.output_path
  source_code_hash = data.archive_file.hono_lambda_zip.output_base64sha256
}

resource "aws_cloudwatch_log_group" "hono_lambda_log_group" {
  name = "/aws/lambda/${aws_lambda_function.hono_lambda.function_name}"
}