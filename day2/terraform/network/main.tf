#vpc 1
resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
  #region us-east-1
  region = "us-east-1"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc1"
  }

}

#vpc 2
resource "aws_vpc" "vpc2" {
  cidr_block = "10.1.0.0/16"
  #region us-east-2
  region = "us-east-2"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc2"
  }
}

#subnet of vpc1
resource "aws_subnet" "vpc1_subnet"{
  region = "us-east-1"
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "vpc1_subnet"
  }
}

#subnet of vpc2
resource "aws_subnet" "vpc2_subnet" {
  region = "us-east-2"
  vpc_id = aws_vpc.vpc2.id
  cidr_block = "10.1.0.0/24"

  tags = {
    Name = "vpc2_subnet"
  }
}

#route table of vpc1
resource "aws_route_table" "vpc1_rt" {
  region = "us-east-1"
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "vpc1_rt"
  }
}

#route table of vpc2
resource "aws_route_table" "vpc2_rt" {
  region = "us-east-2"
  vpc_id = aws_vpc.vpc2.id

  tags = {
    Name = "vpc2_rt"
  }
}

#route table association of vpc1
resource "aws_route_table_association" "vpc1_rta" {
  region = "us-east-1"
  subnet_id      = aws_subnet.vpc1_subnet.id
  route_table_id = aws_route_table.vpc1_rt.id
}

#route table association of vpc2
resource "aws_route_table_association" "vpc2_rta" {
  region = "us-east-2"
  subnet_id      = aws_subnet.vpc2_subnet.id
  route_table_id = aws_route_table.vpc2_rt.id
}

#internet gateway of vpc1
resource "aws_internet_gateway" "vpc1_igw" {
  vpc_id = aws_vpc.vpc1.id
  region = "us-east-1"
  tags = {
    Name = "vpc1_igw"
  }

}

#internet gateway of vpc2
resource "aws_internet_gateway" "vpc2_igw" {
  vpc_id = aws_vpc.vpc2.id
  region = "us-east-2"
  tags = {
    Name = "vpc2_igw"
  }

}

#route to internet gateway of vpc1
resource "aws_route" "vpc1_route" {
  region = "us-east-1"
  route_table_id         = aws_route_table.vpc1_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc1_igw.id
}
#route to internet gateway of vpc2
resource "aws_route" "vpc2_route" {
  region = "us-east-2"
  route_table_id         = aws_route_table.vpc2_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc2_igw.id
}

#vpc peering connection: vpc1 (requester) -> vpc2 (accepter)
resource "aws_vpc_peering_connection" "vpc1_to_vpc2" {
  region = "us-east-1"
  peer_owner_id = var.peer_owner_id
  peer_vpc_id   = aws_vpc.vpc2.id
  peer_region = "us-east-2"
  vpc_id        = aws_vpc.vpc1.id

  auto_accept = false

  tags = {
    Name = "vpc1-to-vpc2"
  }
}

# Accept the peering from the accepter account if same account; otherwise, manual acceptance required.
resource "aws_vpc_peering_connection_accepter" "accept_vpc1_to_vpc2" {
  region = "us-east-2"
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc1_to_vpc2.id
  auto_accept = true

  tags = {
    Name = "vpc1-to-vpc2-accepter"
  }
}

# Routes for VPC peering
resource "aws_route" "vpc1_to_vpc2_route" {
  region = "us-east-1"
  route_table_id         = aws_route_table.vpc1_rt.id
  destination_cidr_block = aws_vpc.vpc2.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc1_to_vpc2.id
  depends_on = [aws_vpc_peering_connection_accepter.accept_vpc1_to_vpc2]
}

resource "aws_route" "vpc2_to_vpc1_route" {
  region = "us-east-2"
  route_table_id         = aws_route_table.vpc2_rt.id
  destination_cidr_block = aws_vpc.vpc1.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc1_to_vpc2.id
  depends_on = [aws_vpc_peering_connection_accepter.accept_vpc1_to_vpc2]
}


#security group of vpc1
resource "aws_security_group" "vpc1_sg" {
  region = "us-east-1"
  name = "vpc1_sg"
  description = "Allow ssh and all traffic from vpc2"
  vpc_id = aws_vpc.vpc1.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH from vpc2" 
  }

  #all icmp v4 traffic from vpc2 to test ping
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [aws_vpc.vpc2.cidr_block]
    description = "Allow ICMP from vpc2"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "vpc1_sg"
  }
}


#security group of vpc2
resource "aws_security_group" "vpc2_sg" {
  region = "us-east-2"
  name = "vpc2_sg"
  description = "Allow ssh and all traffic from vpc1"
  vpc_id = aws_vpc.vpc2.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH from vpc1" 
  }

  #all icmp v4 traffic from vpc1 to test ping
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [aws_vpc.vpc1.cidr_block]
    description = "Allow ICMP from vpc1"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "vpc2_sg"
  }
}
