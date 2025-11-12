#target group
resource "aws_lb_target_group" "weather_app_target_group" {
  name = "weather-app-target-group" #does not allow underscores so needs to use hyphens
  port = 80
  protocol = "HTTP"
  vpc_id = data.aws_vpc.weather_vpc.id
  target_type = "instance"

  health_check {
    path = "/"
  }
}

#load balancer
resource "aws_lb" "weatther_app_lb" {
  name = "weather-app-lb"
  internal = false
  load_balancer_type = "application"
  security_groups = [data.aws_security_group.weather_sg.id]
  subnets = [for subnet in data.aws_subnets.weather_subnets.ids : subnet] #https://developer.hashicorp.com/terraform/language/expressions/for
}

#listener
resource "aws_lb_listener" "weather_app_listener" {
  load_balancer_arn = aws_lb.weatther_app_lb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.weather_app_target_group.arn
  }
}

#auto scaling group

resource "aws_autoscaling_group" "weather_app_asg" {
  name = "weather-app-asg"
  min_size = 1
  max_size = 1
  desired_capacity = 1

  vpc_zone_identifier = [for subnet in data.aws_subnets.weather_subnets.ids : subnet]
  launch_template {
    id = aws_launch_template.weather_app_launch_template.id
    version = "$Latest"
  }
}
