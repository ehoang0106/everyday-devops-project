data "aws_vpc" "vpc1" {
  region = "us-east-1"
  filter {
    name   = "tag:Name"
    values = ["vpc1"]
  }
}

data "aws_vpc" "vpc2" {
  region = "us-east-2"
  filter {
    name   = "tag:Name"
    values = ["vpc2"]
  }
}

data "aws_subnet" "vpc1_subnet" {
  region = "us-east-1"
  filter {
    name   = "tag:Name"
    values = ["vpc1_subnet"]
  }
  vpc_id = data.aws_vpc.vpc1.id
}

data "aws_subnet" "vpc2_subnet" {
  region = "us-east-2"
  filter {
    name   = "tag:Name"
    values = ["vpc2_subnet"]
  }
  vpc_id = data.aws_vpc.vpc2.id
}

data "aws_security_group" "vpc1_sg" {
  region = "us-east-1"
  filter {
    name   = "tag:Name"
    values = ["vpc1_sg"]
  }
  vpc_id = data.aws_vpc.vpc1.id
}

data "aws_security_group" "vpc2_sg" {
  region = "us-east-2"
  filter {
    name   = "tag:Name"
    values = ["vpc2_sg"]
  }
  vpc_id = data.aws_vpc.vpc2.id
}