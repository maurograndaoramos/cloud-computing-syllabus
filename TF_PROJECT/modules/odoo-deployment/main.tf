resource "kubernetes_deployment" "odoo" {
  metadata {
    name      = "odoo"
    namespace = var.namespace
  }

  spec {
    replicas = var.replica_count

    selector {
      match_labels = {
        app = "odoo"
      }
    }

    template {
      metadata {
        labels = {
          app = "odoo"
        }
      }

      spec {
        container {
          name  = "odoo"
          image = "odoo:latest"
          port {
            container_port = 8069
          }

          env {
            name  = "HOST"
            value = "postgres"  # Replace with your PostgreSQL service name
          }

          env {
            name  = "USER"
            value = "odoo"  # Replace with your PostgreSQL username
          }

          env {
            name  = "PASSWORD"
            value = "odoo"  # Replace with your PostgreSQL password
          }

          env {
            name  = "DB_NAME"
            value = "odoo"  # Replace with your PostgreSQL database name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "odoo" {
  metadata {
    name      = "odoo-service"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = kubernetes_deployment.odoo.spec.0.template.0.metadata.0.labels.app
    }

    port {
      port        = 80
      target_port = 8069
    }

    type = "ClusterIP"
  }
}