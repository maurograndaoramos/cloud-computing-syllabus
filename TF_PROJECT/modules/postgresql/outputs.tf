output "postgres_service_name" {
  description = "The name of the PostgreSQL service"
  value       = kubernetes_service.postgres.metadata[0].name
}