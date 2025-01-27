provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "client_namespace" {
  metadata {
    name = "${var.client_name}-${var.environment}"
  }
}

module "kubernetes_cluster" {
  source     = "./modules/kubernetes-cluster"
  namespace  = kubernetes_namespace.client_namespace.metadata[0].name
}

module "odoo_deployment" {
  depends_on = [ module.postgresql ]
  source       = "./modules/odoo-deployment"
  namespace    = kubernetes_namespace.client_namespace.metadata[0].name
  replica_count = var.replica_count
}

module "ingress" {
  source     = "./modules/ingress"
  domain_name = var.domain_name
  namespace  = kubernetes_namespace.client_namespace.metadata[0].name
}

module "postgresql" {
  source     = "./modules/postgresql"
  namespace  = kubernetes_namespace.client_namespace.metadata[0].name
}