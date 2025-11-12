data "aws_security_group" "weather_sg" {
  filter {
    name = "tag:Name"
    values = ["weather_sg"]
  }
}

data "aws_vpc" "weather_vpc" {
  filter {
    name = "tag:Name"
    values = ["weather_vpc"]
  }
}

data "aws_subnets" "weather_subnets" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.weather_vpc.id]
  }
}