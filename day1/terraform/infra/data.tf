data "aws_vpc" "day1_devops_vpc" {
  filter {
    name   = "tag:Name"
    values = ["day1_devops_vpc"]
  }
}

data "aws_subnet" "day1_devops_subnet" {
  filter {
    name   = "tag:Name"
    values = ["day1_devops_subnet"]
  }
}

data "aws_security_group" "day1_devops_sg" {
  filter {
    name   = "tag:Name"
    values = ["day1_devops_sg"]
  }
}