output "odoo_url" {
  description = "The URL for accessing the Odoo application"
  value       = "http://${kubernetes_service.odoo.metadata[0].name}.${var.namespace}.svc.cluster.local:8069"
}