output "ec2_public_ip" {
  value = aws_instance.snowplow_collector.public_ip
}

output "ec2_public_dns" {
  value = aws_instance.snowplow_collector.public_dns
}

output "collector_endpoint" {
  value = "http://${aws_instance.snowplow_collector.public_ip}:8080"
}

output "datalake_bucket_name" {
  description = "Name of the S3 bucket used for Snowplow event data."
  value       = aws_s3_bucket.snowplow_data_lake.bucket
}

output "datalake_bucket_arn" {
  description = "ARN of the S3 bucket used for Snowplow event data."
  value       = aws_s3_bucket.snowplow_data_lake.arn
}

output "collector_good_kinesis_arn" {
  description = "ARN of the existing collector-good Kinesis stream."
  value       = aws_kinesis_stream.enriched_good.arn
}

output "events_bad_kinesis_arn" {
  description = "ARN of the existing bad events Kinesis stream."
  value       = aws_kinesis_stream.events_bad.arn
}

output "enriched_good_kinesis_arn" {
  description = "ARN of the existing enriched-good Kinesis stream."
  value       = aws_kinesis_stream.enriched_good.arn
}
# -----------------------------------------------------------------------------
# Firehose outputs
# -----------------------------------------------------------------------------

output "good_firehose_name" {
  description = "Firehose delivery stream for enriched good Snowplow events."
  value       = aws_kinesis_firehose_delivery_stream.enriched_good.name
}

output "bad_firehose_name" {
  description = "Firehose delivery stream for enriched bad Snowplow events."
  value       = aws_kinesis_firehose_delivery_stream.enriched_bad.name
}