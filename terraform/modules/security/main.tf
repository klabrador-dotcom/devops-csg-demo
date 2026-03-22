# --- IAM ROLES ---

# Task Execution Role: Allows ECS to pull images from ECR and send logs to CloudWatch
resource "aws_iam_role" "ecs_execution_role" {
  name = "csgtest-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })

  tags = { name = "csgtest" }
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# --- SECURITY GROUPS ---

# 1. ALB Security Group: Allows web traffic (Port 80) from the internet
resource "aws_security_group" "alb_sg" {
  name   = "csgtest-alb-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { name = "csgtest" }
}

# 2. ECS Security Group: Only allows traffic from the ALB
resource "aws_security_group" "ecs_sg" {
  name   = "csgtest-ecs-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { name = "csgtest" }
}

# 3. RDS Security Group: Only allows traffic from the ECS Tasks
resource "aws_security_group" "rds_sg" {
  name   = "csgtest-rds-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  tags = { name = "csgtest" }
}
