resource "aws_iam_policy" "hono_lambda_policy" {
  name        = "${var.env}-hono-lambda-policy"
  description = "IAM policy for Hono Lambda function"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "hono_lambda_exec" {
  name = "${var.env}-hono-lambda-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "hono_lambda_policy_attachment" {
  policy_arn = aws_iam_policy.hono_lambda_policy.arn
  role       = aws_iam_role.hono_lambda_exec.name
}

# Lambda基本実行ロール（AWS管理ポリシー）をアタッチ
resource "aws_iam_role_policy_attachment" "hono_lambda_basic_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.hono_lambda_exec.name
}

# API Gateway CloudWatch Logs用のIAMロール
resource "aws_iam_role" "api_gateway_cloudwatch_role" {
  name = "${var.env}-api-gateway-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# API Gateway CloudWatch Logs用のポリシー
resource "aws_iam_role_policy" "api_gateway_cloudwatch_policy" {
  name = "${var.env}-api-gateway-cloudwatch-policy"
  role = aws_iam_role.api_gateway_cloudwatch_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:FilterLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}
