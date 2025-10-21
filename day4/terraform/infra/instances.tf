resource "aws_instance" "my_ec2" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = data.aws_subnet.my_subnet.id
  vpc_security_group_ids = [data.aws_security_group.my_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "my_ec2"
  }
  


}