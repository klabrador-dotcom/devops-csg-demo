resource "aws_db_subnet_group" "db_net" {
  name       = "csg-db-subnets-${var.environment}"
  subnet_ids = var.private_subnet_ids
  tags       = { name = "csgtest" }
}

resource "aws_db_instance" "db" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "15.3"
  instance_class       = "db.t3.micro"
  db_name              = "csgdb"
  username             = "csgadmin"
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.db_net.name
  skip_final_snapshot  = true
  tags                 = { name = "csgtest" }
}

output "db_endpoint" { value = aws_db_instance.db.endpoint }
