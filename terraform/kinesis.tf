


resource "aws_kinesis_stream" "collector_good" {
  name = var.collector_stream_good
  stream_mode_details {
    stream_mode = "ON_DEMAND"
  }

  tags = {
    Environment = "MVP"
    Pipeline    = "Snowplow"
  }
}

resource "aws_kinesis_stream" "events_bad" {
  name = var.collector_stream_bad
  stream_mode_details {
    stream_mode = "ON_DEMAND"
  }

  tags = {
    Environment = "MVP"
    Pipeline    = "Snowplow"
  }
}

resource "aws_kinesis_stream" "enriched_good" {
  name = var.enriched_stream_good
  stream_mode_details {
    stream_mode = "ON_DEMAND"
  }

  tags = {
    Environment = "MVP"
    Pipeline    = "Snowplow"
  }
}