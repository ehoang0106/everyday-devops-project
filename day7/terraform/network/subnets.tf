resource "aws_subnet" "weather_subnet1" {
  vpc_id = aws_vpc.weather_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-west-1a"

  tags = {
    Name = "weather_subnet1"
  }
}

resource "aws_subnet" "weather_subnet2" {
  vpc_id = aws_vpc.weather_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-1c"

  tags = {
    Name = "weather_subnet2"
  }
}