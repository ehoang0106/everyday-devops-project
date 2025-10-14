#vpc

resource "aws_vpc" "devops_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "devops_vpc"
  }
}

#subnet

resource "aws_subnet" "devops_subnet" {
  vpc_id = aws_vpc.devops_vpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "devops_subnet"
  }
}

#internet gateway

resource "aws_internet_gateway" "devops_igw" {
  vpc_id = aws_vpc.devops_vpc.id

  tags = {
    Name = "devops_igw"
  }
}


#route table

resource "aws_route_table" "devops_route_table" {
  vpc_id = aws_vpc.devops_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops_igw.id
  }

  tags = {
    Name = "devops_route_table"
  }
}

#route table association
resource "aws_route_table_association" "devops_route_table_association" {
  subnet_id      = aws_subnet.devops_subnet.id
  route_table_id = aws_route_table.devops_route_table.id
}

#security group

#allow ssh

resource "aws_security_group" "devops_sg" {
  vpc_id = aws_vpc.devops_vpc.id
  name   = "devops_sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "devops_sg"
  }
}