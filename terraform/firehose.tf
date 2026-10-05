# =============================================================================
# GOOD EVENTS FIREHOSE
#
# Source:
#   snowplow-mvp-enriched-good
#
# Destination:
#   S3 /events/
#
# Flow:
#
#   Kinesis Data Streams
#          │
#          ▼
#       Firehose
#          │
#          ▼
#       S3 bucket
# =============================================================================

resource "aws_kinesis_firehose_delivery_stream" "enriched_good" {

  # ---------------------------------------------------------------------------
  # Delivery stream name
  # ---------------------------------------------------------------------------

  name = local.good_firehose_name

  # Firehose will deliver the data to S3.
  #
  # "s3" is the older destination type.
  # "extended_s3" is the current/recommended configuration.
  destination = "extended_s3"

  # ---------------------------------------------------------------------------
  # Kinesis Data Streams source
  # ---------------------------------------------------------------------------
  #
  # Firehose consumes from the EXISTING enriched-good stream.
  #
  # We are deliberately not creating another Kinesis stream here.
  # ---------------------------------------------------------------------------

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.enriched_good.arn
    role_arn           = aws_iam_role.firehose_good.arn
  }

  # ---------------------------------------------------------------------------
  # S3 destination
  # ---------------------------------------------------------------------------

  extended_s3_configuration {

    # IAM role Firehose assumes to access Kinesis + S3.
    role_arn = aws_iam_role.firehose_good.arn

    # Destination bucket.
    bucket_arn = aws_s3_bucket.snowplow_data_lake.arn

    # -------------------------------------------------------------------------
    # S3 object prefix
    #
    # Firehose automatically adds its time-based hierarchy after this prefix.
    #
    # Example:
    #
    # events/2026/10/03/13/...
    # -------------------------------------------------------------------------

    prefix = "events/"

    # -------------------------------------------------------------------------
    # Where Firehose delivery errors should go.
    # -------------------------------------------------------------------------

    error_output_prefix = "firehose-errors/good/"

    # -------------------------------------------------------------------------
    # MVP buffering
    #
    # 5 MB OR 60 seconds, whichever happens first.
    #
    # This makes testing much easier than the default 5-minute interval.
    #
    # Production should be tuned against actual traffic and downstream
    # object-size requirements.
    # -------------------------------------------------------------------------

    buffering_size     = 5
    buffering_interval = 60

    # -------------------------------------------------------------------------
    # Compress delivered S3 objects.
    #
    # GZIP is useful here because Snowplow enriched events are text-based.
    # -------------------------------------------------------------------------

    compression_format = "GZIP"
  }
}

# =============================================================================
# BAD EVENTS FIREHOSE
#
# Source:
#   snowplow-mvp-enriched-bad
#
# Destination:
#   S3 /failed-events/
# =============================================================================

resource "aws_kinesis_firehose_delivery_stream" "enriched_bad" {

  name = local.bad_firehose_name

  destination = "extended_s3"

  # ---------------------------------------------------------------------------
  # Existing Kinesis source
  # ---------------------------------------------------------------------------

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.events_bad.arn
    role_arn           = aws_iam_role.firehose_bad.arn
  }

  # ---------------------------------------------------------------------------
  # S3 destination
  # ---------------------------------------------------------------------------

  extended_s3_configuration {

    role_arn = aws_iam_role.firehose_bad.arn

    bucket_arn = aws_s3_bucket.snowplow_data_lake.arn

    # Failed/bad records have their own logical area.
    prefix = "failed-events/"

    # Firehose-level delivery failures get another separate location.
    error_output_prefix = "firehose-errors/bad/"

    buffering_size     = 5
    buffering_interval = 60

    compression_format = "GZIP"
  }
}