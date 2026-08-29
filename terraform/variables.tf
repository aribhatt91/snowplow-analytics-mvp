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

variable "snowplow_datalake_bucket_name" {
  description = "sp-datalake-2026-aritrab"
  type        = string
}

variable "snowplow_schemas_bucket_name" {
  description = "sp-schema-repo-2026-aritrab"
  type        = string
}