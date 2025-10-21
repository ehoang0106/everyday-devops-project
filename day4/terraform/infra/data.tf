data "aws_subnet" "my_subnet" {
  filter {
    name = "tag:Name"
    values = ["my_subnet"]
  }
}

data "aws_security_group" "my_sg" {
  filter {
    name = "group-name"
    values = ["my_sg"]
  }
}