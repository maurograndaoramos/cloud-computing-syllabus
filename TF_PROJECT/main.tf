terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
  }
}

variable "minikube_driver" {
  default = "docker"
}

variable "minikube_cpus" {
  default = 2
}

variable "minikube_memory" {
  default = 4096
}

resource "null_resource" "minikube_profile" {
  provisioner "local-exec" {
    command = <<EOT
    if ! minikube profile list | grep -q "${var.client_name}"; then
      minikube start --profile=${var.client_name} \
        --driver=${var.minikube_driver} \
        --cpus=${var.minikube_cpus} \
        --memory=${var.minikube_memory}
    else
      echo "Minikube profile '${var.client_name}' already exists."
    fi
    EOT
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "kubectl" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "client_namespace" {
  depends_on = [null_resource.minikube_profile]
  metadata {
    name = "${var.client_name}-${var.environment}"
  }
}

data "http" "cert_manager" {
  url = "https://github.com/cert-manager/cert-manager/releases/download/v1.13.1/cert-manager.yaml"
}

resource "local_file" "cert_manager_yaml" {
  filename = "${path.module}/cert-manager.yaml"
  content  = data.http.cert_manager.response_body
}

resource "kubectl_manifest" "cert_manager" {
  yaml_body = file("${path.module}/cert-manager.yaml")
}

resource "null_resource" "wait_for_crds" {
  depends_on = [kubectl_manifest.cert_manager]

  provisioner "local-exec" {
    command = <<EOT
      echo "Waiting for cert-manager CRDs to become available..."
      sleep 30  # Wait for 30 seconds (adjust as needed)
    EOT
  }
}

resource "kubernetes_manifest" "cluster_issuer" {
  depends_on = [null_resource.wait_for_crds]

  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt-prod"
    }
    spec = {
      acme = {
        server = "https://acme-v02.api.letsencrypt.org/directory"
        email  = "fake@example.com"
        privateKeySecretRef = {
          name = "letsencrypt-prod"
        }
        solvers = [
          {
            http01 = {
              ingress = {
                class = "nginx"
              }
            }
          }
        ]
      }
    }
  }
}

module "kubernetes_cluster" {
  source    = "./modules/kubernetes-cluster"
  namespace = kubernetes_namespace.client_namespace.metadata[0].name
}

module "postgresql" {
  source      = "./modules/postgresql"
  namespace   = kubernetes_namespace.client_namespace.metadata[0].name
  db_name     = var.db_name
  db_user     = var.db_user
  db_password = var.db_password
}

module "odoo_deployment" {
  source       = "./modules/odoo-deployment"
  namespace    = kubernetes_namespace.client_namespace.metadata[0].name
  replica_count = var.replica_count
  db_host     = module.postgresql.db_host
  db_user     = module.postgresql.db_user
  db_password = module.postgresql.db_password
  db_name     = module.postgresql.db_name
}

module "ingress" {
  source             = "./modules/ingress"
  domain_name        = var.domain_name
  namespace          = kubernetes_namespace.client_namespace.metadata[0].name
  cluster_issuer_name = kubernetes_manifest.cluster_issuer.manifest.metadata.name
}