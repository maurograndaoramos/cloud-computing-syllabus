variable "domain_name" {
  description = "The domain name for the application"
  type        = string
}

variable "namespace" {
  description = "The namespace for the Ingress resource"
  type        = string
}

variable "cluster_issuer_name" {
  description = "The name of the ClusterIssuer"
  type        = string
}
