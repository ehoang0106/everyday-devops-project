resource "aws_vpc" "weather_vpc" {
  cidr_block = "10.0.0.0/16"
  region = "us-west-1"
  enable_dns_hostnames = true
  enable_dns_support = true


  tags = {
    Name = "weather_vpc"
  }
}

