variable "client_name" {
  description = "The name of the client (Netflix, Meta, Rockstar)"
  type        = string
}

variable "environment" {
  description = "The environment (dev, qa, prod)"
  type        = string
}

variable "domain_name" {
  description = "The domain name for the application"
  type        = string
}

variable "replica_count" {
  description = "Number of replicas for the Odoo application"
  type        = number
  default     = 1
}

variable "namespace" {
  description = "The namespace for the Kubernetes resources"
  type        = string
}