output "ingress_url" {
  description = "The URL for accessing the Odoo application"
  value       = module.ingress.ingress_url
}

output "namespace" {
  description = "The namespace created for the client"
  value       = kubernetes_namespace.client_namespace.metadata[0].name
}