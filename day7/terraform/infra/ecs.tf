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