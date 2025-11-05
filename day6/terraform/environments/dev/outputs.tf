# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

# Security Group Outputs
output "security_group_id" {
  description = "ID of the security group"
  value       = module.security_group.security_group_id
}

# EC2 Outputs
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2.instance_id
}

output "instance_public_ip" {
  description = "Public IP address of the instance"
  value       = module.ec2.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the instance"
  value       = module.ec2.public_dns
}

output "weather_app_url" {
  description = "URL to access the weather app"
  value       = "http://${module.ec2.public_ip}"
}