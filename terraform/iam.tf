
# -----------------------------------------------------------------------------
# Firehose trust policy
#
# This policy answers:
#
# "Who is allowed to assume this IAM role?"
#
# The answer is Amazon Data Firehose.
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "firehose_assume_role" {
  statement {
    sid    = "AllowFirehoseToAssumeRole"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

# -----------------------------------------------------------------------------
# IAM role used by the GOOD Firehose delivery stream.
# -----------------------------------------------------------------------------

resource "aws_iam_role" "firehose_good" {
  name = "snowplow-mvp-firehose-good-role"

  assume_role_policy = data.aws_iam_policy_document.firehose_assume_role.json

  tags = {
    Name    = "snowplow-mvp-firehose-good-role"
    Purpose = "Firehose delivery from enriched good events to S3"
  }
}

# -----------------------------------------------------------------------------
# Permissions for the GOOD Firehose stream
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "firehose_good" {

  # ---------------------------------------------------------------------------
  # Read from the existing enriched-good Kinesis stream
  # ---------------------------------------------------------------------------
  statement {
    sid    = "ReadEnrichedGoodStream"
    effect = "Allow"

    actions = [
      "kinesis:DescribeStream",
      "kineses:DescribeStreamSummary",
      "kinesis:GetShardIterator",
      "kinesis:GetRecords",
      "kinesis:ListShards"
    ]

    resources = [
      aws_kinesis_stream.enriched_good.arn
    ]
  }

  # ---------------------------------------------------------------------------
  # Write to the Snowplow event-data S3 bucket
  # ---------------------------------------------------------------------------
  statement {
    sid    = "WriteEventsToS3"
    effect = "Allow"

    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]

    resources = [
      aws_s3_bucket.snowplow_data_lake.arn,
      "${aws_s3_bucket.snowplow_data_lake.arn}/*"
    ]
  }
}

resource "aws_iam_role_policy" "firehose_good" {
  name = "snowplow-mvp-firehose-good-policy"
  role = aws_iam_role.firehose_good.id

  policy = data.aws_iam_policy_document.firehose_good.json
}

# -----------------------------------------------------------------------------
# IAM role used by the BAD Firehose delivery stream.
# -----------------------------------------------------------------------------

resource "aws_iam_role" "firehose_bad" {
  name = "snowplow-mvp-firehose-bad-role"

  assume_role_policy = data.aws_iam_policy_document.firehose_assume_role.json

  tags = {
    Name    = "snowplow-mvp-firehose-bad-role"
    Purpose = "Firehose delivery from enriched bad events to S3"
  }
}

# -----------------------------------------------------------------------------
# Permissions for the BAD Firehose stream
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "firehose_bad" {

  # ---------------------------------------------------------------------------
  # Read from the existing enriched-bad Kinesis stream
  # ---------------------------------------------------------------------------
  statement {
    sid    = "ReadEnrichedBadStream"
    effect = "Allow"

    actions = [
      "kinesis:DescribeStream",
      "kinesis:GetShardIterator",
      "kinesis:GetRecords",
      "kinesis:ListShards"
    ]

    resources = [
      aws_kinesis_stream.events_bad.arn
    ]
  }

  # ---------------------------------------------------------------------------
  # Write failed events to the S3 bucket
  # ---------------------------------------------------------------------------
  statement {
    sid    = "WriteFailedEventsToS3"
    effect = "Allow"

    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]

    resources = [
      aws_s3_bucket.snowplow_data_lake.arn,
      "${aws_s3_bucket.snowplow_data_lake.arn}/*"
    ]
  }
}

resource "aws_iam_role_policy" "firehose_bad" {
  name = "snowplow-mvp-firehose-bad-policy"
  role = aws_iam_role.firehose_bad.id

  policy = data.aws_iam_policy_document.firehose_bad.json
}