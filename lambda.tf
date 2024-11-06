
data "archive_file" "lambda_function_file" {
  type        = "zip"
  source_file = "lambda/lambda_function.py"
  output_path = "lambda/lambda_function.zip"
}

resource "aws_lambda_function" "dynatrace_lambda" {
  function_name = "${local.name_prefix}-dynatrace-lambda"
  description   = "Lambda function for Dynatrace monitoring"

  handler = "lambda_function.lambda_handler"
  runtime = "python3.12"
  timeout = 60

  filename         = "lambda/lambda_function.zip"
  source_code_hash = data.archive_file.lambda_function_file.output_base64sha256
  publish          = true

  role = aws_iam_role.dynatrace_lambda_role.arn

  environment {
    variables = {
      DT_CUSTOM_PROP = "${local.name_prefix}-me"
    }
  }

  tags = merge(
    local.tags,
    {
      "app:layer" = "monitoring"
    }
  )
}

resource "aws_iam_role" "dynatrace_lambda_role" {
  name = "${local.name_prefix}-dynatrace-lambda-${local.region}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    local.tags,
    {
      "app:layer" = "monitoring"
    }
  )
}

resource "aws_iam_role_policy_attachment" "dynatrace_lambda_policy_attachment" {
  role       = aws_iam_role.dynatrace_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
