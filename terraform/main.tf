data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Find an existing Ubuntu AMI (Amazon Machine Image) and if multiple AMIs exist return the most recent one
# AWS account/owner ID associated with Canonical (publisher of offcial Ubuntu AMIs on AWS) = 099720109477

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name = "name"

    values = [
      "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
    ]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create Security Group

resource "aws_security_group" "snowplow_collector" {
  name        = "snowplow-collector-sg"
  description = "Security group for Snowplow Collector"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = var.allowed_cidr_blocks_ssh
  }

  ingress {
    description = "Snowplow Collector"

    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"

    cidr_blocks = var.allowed_cidr_blocks_collector
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an EC2 Key pair - add the keys to the specific path

resource "aws_key_pair" "snowplow" {
  key_name   = "snowplow-mvp-key"
  public_key = file("${path.module}/keys/snowplow-mvp-key.pub")
}

resource "aws_instance" "snowplow_collector" {

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id = data.aws_subnets.default.ids[0]

  vpc_security_group_ids = [
    aws_security_group.snowplow_collector.id
  ]

  key_name = aws_key_pair.snowplow.key_name

  associate_public_ip_address = true

  tags = {
    Name = "snowplow-collector-mvp"
  }
}