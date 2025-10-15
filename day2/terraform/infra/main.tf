#ec2 instance in vpc1

resource "aws_instance" "vpc1_instance" {
  region = "us-east-1"
  ami = "ami-0341d95f75f311023"
  instance_type = "t2.micro"
  subnet_id = data.aws_subnet.vpc1_subnet.id

  vpc_security_group_ids = [data.aws_security_group.vpc1_sg.id]
  associate_public_ip_address = true


  tags = {
    Name = "vpc1_intance"
  }

}

#ec2 instance in vpc2
resource "aws_instance" "vpc2_instance" {
  region = "us-east-2"
  ami = "ami-0199d4b5b8b4fde0e"
  instance_type = "t2.micro"
  subnet_id = data.aws_subnet.vpc2_subnet.id


  vpc_security_group_ids = [data.aws_security_group.vpc2_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "vpc2_instance"
  }

}
