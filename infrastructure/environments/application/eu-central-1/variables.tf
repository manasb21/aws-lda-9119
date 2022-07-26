variable "environment" {
  type = string
}

variable "handler" {
  description = "The function name which will be executed"
}

variable "db_name" {
  type = string
  description = "database name"
}

variable "context_root" {
  type = string
}
