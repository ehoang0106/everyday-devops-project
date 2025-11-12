resource "aws_launch_template" "weather_app_launch_template" {
  name = "weather-app-launch-template"
  image_id = "ami-01eb4eefd88522422"
  #instance_type = "t3.small"

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [data.aws_security_group.weather_sg.id]
  }

  iam_instance_profile {
    name = "ecsInstanceRole"
  }

  # read the local user_data.sh and supply it to the launch template (base64-encoded)
  user_data = filebase64("${path.module}/user_data.sh")

  security_group_names = [data.aws_security_group.weather_sg.id ]

  tags = {
    Name = "weather-app-launch-template"
  }
}


