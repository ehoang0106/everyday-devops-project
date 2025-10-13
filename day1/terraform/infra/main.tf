#ec2 instance

resource "aws_instance" "day1_devops_ec2" {
  ami = var.ami
  instance_type = "t3.micro"
  subnet_id = data.aws_subnet.day1_devops_subnet.id
  vpc_security_group_ids = [data.aws_security_group.day1_devops_sg.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
    delete_on_termination = true
  }
  key_name = "day1-devops-ec2-kp"
  #install SSM Agent
  user_data = <<-EOF
              #!/bin/bash
              sudo snap install amazon-ssm-agent --classic
              sudo snap start amazon-ssm-agent
              EOF

  iam_instance_profile = "AllowAccessSessionManagerToSSHToEC2"
  tags = {
    Name = "day1_devops_ec2"
  }
}