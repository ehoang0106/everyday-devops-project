resource "aws_route_table" "weather_internet_rt" {
  vpc_id = aws_vpc.weather_vpc.id

  tags = {
    Name = "weather_internet_rt"
  }
}

resource "aws_route_table_association" "weather_internet_rt_assoc1" {
  subnet_id      = aws_subnet.weather_subnet1.id
  route_table_id = aws_route_table.weather_internet_rt.id
}

resource "aws_route_table_association" "weather_internet_rt_assoc2" {
  subnet_id      = aws_subnet.weather_subnet2.id
  route_table_id = aws_route_table.weather_internet_rt.id
}

resource "aws_internet_gateway" "weather_igw" {
  vpc_id = aws_vpc.weather_vpc.id

  tags = {
    Name = "weather_igw"
  }
}

resource "aws_route" "weather_internet_route" {
  route_table_id         = aws_route_table.weather_internet_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.weather_igw.id

  depends_on = [aws_internet_gateway.weather_igw]
}

