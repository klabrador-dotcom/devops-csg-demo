resource "aws_ecr_repository" "app" {
  name                 = "csgtest-repository-${var.environment}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    name = "csgtest"
  }
}

# This policy prevents your AWS bill from growing by cleaning up old images
resource "aws_ecr_lifecycle_policy" "repo_policy" {
  repository = aws_ecr_repository.app.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 10 images"
      selection = {
        tagStatus     = "any"
        countType     = "imageCountMoreThan"
        countNumber   = 10
      }
      action = {
        type = "expire"
      }
    }]
  })
}

output "repository_url" {
  value = aws_ecr_repository.app.repository_url
}
