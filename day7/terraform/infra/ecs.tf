#ecs cluster

resource "aws_ecs_cluster" "weather_cluster" {
  name = "weather-cluster"
}

#ecs task definition
resource "aws_ecs_task_definition" "weather_app_task" {
  family = "weather-app-task"
  network_mode = "bridge"
  requires_compatibilities = ["EC2"]
  cpu = 1024
  memory = 2048
  task_role_arn = data.aws_iam_role.ecs_task_execution_role.arn
  execution_role_arn = data.aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name = "weather-app-container"
      image = "706572850235.dkr.ecr.us-west-1.amazonaws.com/weather-app:latest"
      essential = true
      memory = 2048
      cpu = 1024
      portMappings = [
        {
          containerPort = 80
          hostPort = 80
          protocol = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/weather-app-logs"
          "awslogs-region"        = "us-west-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture = "X86_64"
  }
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
  # launch_type = "EC2"
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