# Subnet Outputs
output "weather_subnet1_id" {
  description = "ID of weather subnet 1"
  value       = aws_subnet.weather_subnet1.id
}

output "weather_subnet1_cidr" {
  description = "CIDR block of weather subnet 1"
  value       = aws_subnet.weather_subnet1.cidr_block
}

output "weather_subnet1_az" {
  description = "Availability zone of weather subnet 1"
  value       = aws_subnet.weather_subnet1.availability_zone
}

output "weather_subnet2_id" {
  description = "ID of weather subnet 2"
  value       = aws_subnet.weather_subnet2.id
}

output "weather_subnet2_cidr" {
  description = "CIDR block of weather subnet 2"
  value       = aws_subnet.weather_subnet2.cidr_block
}

output "weather_subnet2_az" {
  description = "Availability zone of weather subnet 2"
  value       = aws_subnet.weather_subnet2.availability_zone
}

output "weather_subnet_ids" {
  description = "List of all weather subnet IDs"
  value       = [aws_subnet.weather_subnet1.id, aws_subnet.weather_subnet2.id]
}

# Security Group Outputs
output "weather_sg_id" {
  description = "ID of weather security group"
  value       = aws_security_group.weather_sg.id
}

output "weather_sg_arn" {
  description = "ARN of weather security group"
  value       = aws_security_group.weather_sg.arn
}

output "weather_sg_name" {
  description = "Name of weather security group"
  value       = aws_security_group.weather_sg.name
}

# Internet Gateway Outputs
output "weather_igw_id" {
  description = "ID of weather internet gateway"
  value       = aws_internet_gateway.weather_igw.id
}

output "weather_igw_arn" {
  description = "ARN of weather internet gateway"
  value       = aws_internet_gateway.weather_igw.arn
}

# Route Table Outputs
output "weather_internet_rt_id" {
  description = "ID of weather internet route table"
  value       = aws_route_table.weather_internet_rt.id
}

output "weather_internet_rt_arn" {
  description = "ARN of weather internet route table"
  value       = aws_route_table.weather_internet_rt.arn
}

# Route Table Association Outputs
output "weather_internet_rt_assoc1_id" {
  description = "ID of route table association 1"
  value       = aws_route_table_association.weather_internet_rt_assoc1.id
}

output "weather_internet_rt_assoc2_id" {
  description = "ID of route table association 2"
  value       = aws_route_table_association.weather_internet_rt_assoc2.id
}
