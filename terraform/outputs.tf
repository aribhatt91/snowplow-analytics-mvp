output "ec2_public_ip" {
  value = aws_instance.snowplow_collector.public_ip
}

output "ec2_public_dns" {
  value = aws_instance.snowplow_collector.public_dns
}

output "collector_endpoint" {
  value = "http://${aws_instance.snowplow_collector.public_ip}:8080"
}