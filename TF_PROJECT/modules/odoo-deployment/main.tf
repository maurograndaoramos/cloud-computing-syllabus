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
        init_container {
          name  = "wait-for-postgres"
          image = "busybox:1.31.1"
          command = [
            "sh", "-c",
            "until nc -zv ${var.db_host} 5432; do echo 'Waiting for PostgreSQL...'; sleep 5; done;"
          ]
        }

        container {
          name  = "odoo"
          image = "odoo:latest"
          port {
            container_port = 8069
          }

          env {
            name  = "HOST"
            value = var.db_host
          }

          env {
            name  = "USER"
            value = var.db_user
          }

          env {
            name  = "PASSWORD"
            value = var.db_password
          }

          env {
            name  = "DB_NAME"
            value = var.db_name
          }

          command = ["/bin/bash", "-c", "odoo -i base --xmlrpc-port=8069"]
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
      app = kubernetes_deployment.odoo.spec[0].template[0].metadata[0].labels.app
    }

    port {
      port        = 80
      target_port = 8069
    }

    type = "ClusterIP"
  }
}