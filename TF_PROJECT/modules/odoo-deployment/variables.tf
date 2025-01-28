variable "namespace" {
  description = "The namespace for the Odoo deployment"
  type        = string
}

variable "replica_count" {
  description = "Number of replicas for the Odoo application"
  type        = number
}

variable "db_host" {
  description = "The PostgreSQL database host"
  type        = string
}

variable "db_user" {
  description = "The PostgreSQL database user"
  type        = string
}

variable "db_password" {
  description = "The PostgreSQL database password"
  type        = string
}

variable "db_name" {
  description = "The PostgreSQL database name"
  type        = string
}