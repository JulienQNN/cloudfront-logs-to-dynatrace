resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name = "${aws_s3_bucket.backup_bucket.bucket}.s3.amazonaws.com"
    origin_id   = "example-origin"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "example-origin"

    viewer_protocol_policy  = "allow-all"
    realtime_log_config_arn = aws_cloudfront_realtime_log_config.cloudfront_dynatrace_monitoring.arn

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_cloudfront_monitoring_subscription" "additional_metrics" {
  distribution_id = aws_cloudfront_distribution.this.id

  monitoring_subscription {
    realtime_metrics_subscription_config {
      realtime_metrics_subscription_status = "Enabled"
    }
  }
}

resource "aws_iam_role" "cloudfront_dynatrace_role" {
  name = "${local.name_prefix}-cloudfront-dynatrace-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
      }
    ]
  })
}

data "aws_iam_policy_document" "cloudfront_dynatrace_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "kinesis:DescribeStreamSummary",
      "kinesis:DescribeStream",
      "kinesis:ListStreams",
      "kinesis:PutRecord",
      "kinesis:PutRecords"
    ]
    resources = [aws_kinesis_stream.dynatrace_kinesis_stream.arn]
  }
  statement {
    effect    = "Allow"
    actions   = ["kms:GenerateDataKey"]
    resources = [local.local_key_arn]
  }
}

resource "aws_iam_role_policy" "cloudfront_policy" {
  name   = "${local.name_prefix}-cloudfront-dynatrace-policy"
  role   = aws_iam_role.cloudfront_dynatrace_role.id
  policy = data.aws_iam_policy_document.cloudfront_dynatrace_policy_document.json
}

resource "aws_cloudfront_realtime_log_config" "cloudfront_dynatrace_monitoring" {
  name          = "${local.name_prefix}-cloudfront-dynatrace-monitoring"
  sampling_rate = 100

  fields = [
    "timestamp",
    "c-ip",
    "sc-status",
    "cs-method",
    "cs-protocol",
    "cs-host",
    "cs-uri-stem",
    "x-host-header",
    "time-taken",
    "cs-user-agent",
    "cs-cookie"
  ]

  endpoint {
    stream_type = "Kinesis"

    kinesis_stream_config {
      role_arn   = aws_iam_role.cloudfront_dynatrace_role.arn
      stream_arn = aws_kinesis_stream.dynatrace_kinesis_stream.arn
    }
  }
}
