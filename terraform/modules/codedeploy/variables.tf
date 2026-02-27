variable "app_name" {
  description = "Name of the CodeDeploy Application"
  type        = string
  default     = "nithin-task-11-app"
}

variable "dg_name" {
  description = "Name of the CodeDeploy Deployment Group"
  type        = string
  default     = "nithin-task-11-dg"
}

variable "codedeploy_role_arn" {
  description = "IAM Role for CodeDeploy"
  type        = string
  default     = "arn:aws:iam::811738710312:role/codedeploy_role"
}

# These will be passed in from your main root module
variable "cluster_name" { type = string }
variable "service_name" { type = string }
variable "listener_arns" { type = list(string) }
variable "blue_target_group" { type = string }
variable "green_target_group" { type = string }