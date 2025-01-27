output "ingress_url" {
  description = "The URL for accessing the Odoo application"
  value       = "https://${var.domain_name}"
}