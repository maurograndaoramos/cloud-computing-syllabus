variable "namespace" {
  description = "The namespace for the PostgreSQL resources"
  type        = string
}

variable "db_name" {
  description = "The name of the PostgreSQL database"
  type        = string
  default     = "odoo"
}

variable "db_user" {
  description = "The username for the PostgreSQL database"
  type        = string
  default     = "odoo"
}

variable "db_password" {
  description = "The password for the PostgreSQL database"
  type        = string
  default     = "odoo"
}