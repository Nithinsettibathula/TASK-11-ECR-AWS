variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "nithin-task-11-cluster"
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = "nithin-task-11-service"
}

variable "container_name" {
  description = "Name of the container inside the task"
  type        = string
  default     = "nithin-task-11-container"
}

variable "task_role_arn" {
  description = "IAM Role for ECS Task"
  type        = string
  default     = "arn:aws:iam::811738710312:role/ecs_fargate_taskRole"
}

# Networking variables (Passed in from your main.tf later)
variable "subnets" { type = list(string) }
variable "security_groups" { type = list(string) }
variable "target_group_arn" { type = string }