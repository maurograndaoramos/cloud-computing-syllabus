variable "namespace" {
  description = "The namespace for the Odoo deployment"
  type        = string
}

variable "replica_count" {
  description = "Number of replicas for the Odoo application"
  type        = number
}