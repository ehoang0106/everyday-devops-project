data "aws_security_group" "weather_sg" {
  filter {
    name = "tag:Name"
    values = ["weather_sg"]
  }
}