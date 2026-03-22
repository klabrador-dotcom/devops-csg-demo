resource "aws_ecs_cluster" "cluster" {
  name = "csg-cluster-${var.environment}"
  tags = { name = "csgtest" }
}

resource "aws_ecs_task_definition" "task" {
  family                   = "csg-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  # Roles would go here (IAM Module)
  
  container_definitions = jsonencode([{
    name  = "app"
    image = var.container_image
    portMappings = [{ containerPort = 80, hostPort = 80 }]
    environment = [
      { name = "APP_ENV", value = var.environment },
      { name = "DB_HOST", value = var.db_endpoint }
    ]
  }])
  tags = { name = "csgtest" }
}
