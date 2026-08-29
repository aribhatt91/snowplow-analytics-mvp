resource "aws_s3_bucket" "snowplow_data_lake" {
  bucket = var.snowplow_datalake_bucket_name

  tags = {
    Name        = "snowplow-data-lake"
    Environment = "mvp"
    Purpose     = "Snowplow event data lake"
  }
}

resource "aws_s3_bucket" "snowplow_schema_repository" {
  bucket = var.snowplow_schemas_bucket_name

  tags = {
    Name        = "snowplow-schema-repo"
    Environment = "mvp"
    Purpose     = "Snowplow schema repository"
  }
}

resource "aws_s3_bucket_public_access_block" "snowplow_data_lake" {
  bucket = aws_s3_bucket.snowplow_data_lake.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "snowplow_data_lake" {
  bucket = aws_s3_bucket.snowplow_data_lake.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "snowplow_data_lake" {
  bucket = aws_s3_bucket.snowplow_data_lake.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "snowplow_schema_repository" {
  bucket = aws_s3_bucket.snowplow_schema_repository.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "snowplow_schema_repository" {
  bucket = aws_s3_bucket.snowplow_schema_repository.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "snowplow_schema_repository" {
  bucket = aws_s3_bucket.snowplow_schema_repository.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}