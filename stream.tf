resource "aws_kinesis_stream" "dynatrace_kinesis_stream" {
  name = "${local.name_prefix}-dynatrace-kinesis-stream"

  stream_mode_details {
    stream_mode = "ON_DEMAND"
  }

  encryption_type = "KMS"
  kms_key_id      = local.local_key_arn

  tags = merge(
    local.tags,
    {
      "app:layer" = "monitoring"
    }
  )
}
