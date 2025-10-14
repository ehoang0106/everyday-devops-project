data "aws_vpc" "devops_vpc" {
  filter {
    name   = "tag:Name"
    values = ["devops_vpc"]
  }
}

data "aws_subnet" "devops_subnet" {
  filter {
    name   = "tag:Name"
    values = ["devops_subnet"]
  }
}

data "aws_security_group" "devops_sg" {
  filter {
    name   = "tag:Name"
    values = ["devops_sg"]
  }
}