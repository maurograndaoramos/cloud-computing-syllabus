output "db_host" {
  description = "The cluster IP for PostgreSQL"
  value       = kubernetes_service.postgres.spec[0].cluster_ip
}

output "db_user" {
  description = "The PostgreSQL user"
  value       = var.db_user
}

output "db_password" {
  description = "The PostgreSQL password"
  value       = var.db_password
}

output "db_name" {
  description = "The PostgreSQL database name"
  value       = var.db_name
}