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
  protect_from_scale_in = true
  vpc_zone_identifier = [for subnet in data.aws_subnets.weather_subnets.ids : subnet]
  launch_template {
    id = aws_launch_template.weather_app_launch_template.id
    version = "$Latest"
  }
  depends_on = [ aws_ecs_cluster.weather_cluster ]
}

#capacity provider

resource "aws_ecs_capacity_provider" "weather_app_capacity_provider" {
  name = "weather-app-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.weather_app_asg.arn

    managed_scaling {
      status = "ENABLED"
      target_capacity = 100
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 1000
    }

    managed_termination_protection = "ENABLED"
  }
}

resource "aws_ecs_cluster_capacity_providers" "weather_app_cluster_capacity_providers" {
  cluster_name = aws_ecs_cluster.weather_cluster.name
  capacity_providers = [aws_ecs_capacity_provider.weather_app_capacity_provider.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.weather_app_capacity_provider.name
    weight = 100
    base = 1
  }
}

#ecs service

resource "aws_ecs_service" "weather_app_service" {
  name = "weather-app-service"
  cluster = aws_ecs_cluster.weather_cluster.id
  task_definition = aws_ecs_task_definition.weather_app_task.arn
  desired_count = 1
  launch_type = "EC2"
  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.weather_app_capacity_provider.name
    base = 1
    weight = 100
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.weather_app_target_group.arn
    container_name = "weather-app-container"
    container_port = 80
  }

  depends_on = [ aws_lb_listener.weather_app_listener, aws_autoscaling_group.weather_app_asg ]
}

resource "aws_cloudwatch_log_group" "weather_app_log_group" {
  name = "/ecs/weather-app-logs"
  retention_in_days = 7

  tags = {
    Name = "weather-app-log-group"
  }
}