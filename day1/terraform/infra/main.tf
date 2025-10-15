#ec2 instance

resource "aws_instance" "devops_ec2" {
  ami = var.ami
  instance_type = "t3.small"
  subnet_id = data.aws_subnet.devops_subnet.id
  vpc_security_group_ids = [data.aws_security_group.devops_sg.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
    delete_on_termination = true
  }
  key_name = "day1-devops-ec2-kp"
  
  #install script.sh
  user_data = base64encode(file("${path.module}/script.sh"))


  iam_instance_profile = "EC2-instance-nextwork-cicd"
  tags = {
    Name = "devops_ec2"
  }
}