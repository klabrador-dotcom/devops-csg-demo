variable "environment" { type = string }
variable "container_image" { type = string }
variable "db_endpoint" { type = string }
variable "execution_role_arn" { type = string }
variable "ecs_security_group_id" { type = string }

variable "task_role_arn" { 
  type    = string 
  default = null 
}
