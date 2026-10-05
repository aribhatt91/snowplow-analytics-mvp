variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Logical name of the Snowplow project."
  type        = string
  default     = "snowplow-mvp"
}

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "eu-north-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "allowed_cidr_blocks_ssh" {
  description = "CIDR blocks allowed to access the Snowplow collector"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_cidr_blocks_collector" {
  description = "CIDR blocks allowed to access the Snowplow collector"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ubuntu_version" {
  description = "Ubuntu release"
  type        = string
  default     = "22.04"
}

variable "datalake_bucket_name" {
  description = "S3 Bucket that acts as the data lake for Raw Events"
  type        = string
}

variable "schemas_bucket_name" {
  description = "S3 Bucket that acts as a Snowplow schema repository"
  type        = string
}

variable "collector_stream_good" {
  description = "Kinesis Raw Events"
  type        = string
}

variable "collector_stream_bad" {
  description = "Kinesis failed or bad events"
  type        = string
}

variable "enriched_stream_good" {
  description = "Enriched Events"
  type        = string
}

variable "enriched_stream_bad" {
  description = "Enriched failed events"
  type        = string
}