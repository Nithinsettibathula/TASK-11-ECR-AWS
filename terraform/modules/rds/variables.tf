variable "subnet_ids" {
  description = "List of subnet IDs for the RDS subnet group"
  type        = list(string)
}

variable "db_security_group_id" {
  description = "The security group ID for the RDS instance"
  type        = string
}

variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "strapi"
}

variable "db_user" {
  description = "Username for the database"
  type        = string
  default     = "nithinadmin"
}

variable "db_password" {
  description = "Password for the database"
  type        = string
  default     = "SecurePassword123!"
}