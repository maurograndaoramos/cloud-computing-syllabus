resource "kubernetes_ingress_v1" "odoo_ingress" {
  metadata {
    name      = "odoo-ingress"
    namespace = var.namespace
    annotations = {
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
  }

  spec {
    rule {
      host = var.domain_name

      http {
        path {
          path = "/"

          backend {
            service {
              name = "odoo-service"
              port {
                number = 80
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = [var.domain_name]
      secret_name = "odoo-tls-secret"
    }
  }
}