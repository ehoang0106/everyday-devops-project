output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "instance_arn" {
  description = "ARN of the EC2 instance"
  value       = aws_instance.this.arn
}

output "public_ip" {
  description = "Public IP address assigned to the instance"
  value       = aws_instance.this.public_ip
}

output "private_ip" {
  description = "Private IP address assigned to the instance"
  value       = aws_instance.this.private_ip
}

output "public_dns" {
  description = "Public DNS name assigned to the instance"
  value       = aws_instance.this.public_dns
}

output "private_dns" {
  description = "Private DNS name assigned to the instance"
  value       = aws_instance.this.private_dns
}