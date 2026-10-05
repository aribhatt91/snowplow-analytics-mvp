locals {
    common_tags = {
        Project     = var.project_name
        Environment = var.environment
        ManagedBy   = "Terraform"
        Application = "Snowplow"
    }
    good_firehose_name = "${var.project_name}-${var.environment}-enriched-good-to-s3"
    bad_firehose_name  = "${var.project_name}-${var.environment}-enriched-bad-to-s3"
}