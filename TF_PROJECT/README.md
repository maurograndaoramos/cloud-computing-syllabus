# Terraform Project for Multi-Client Kubernetes Deployment

This Terraform project automates the deployment of a Kubernetes cluster with Odoo and PostgreSQL for multiple clients, including (For example purposes only) Netflix, Meta, and Rockstar.

## Features
- 🌍 Supports multiple client environments
- 🔧 Modular and reusable Terraform configurations
- 🔒 TLS certificate automation
- 🚀 Streamlined Kubernetes setup with ingress
- 🏗️ Scalable application with adjustable replicas

## Prerequisites

Ensure you have the following installed before proceeding:

| Component     | Version  | Installation Guide                 |
|---------------|----------|-------------------------------------|
| Terraform     | >= 1.3.0 | [terraform.io/downloads](https://www.terraform.io/downloads) |
| Minikube      | >= 1.30  | [minikube.sigs.k8s.io](https://minikube.sigs.k8s.io/docs/start/) |
| kubectl       | >= 1.26  | [kubernetes.io/docs/tasks/tools/](https://kubernetes.io/docs/tasks/tools/) |
| Docker        | >= 20.10 | [docs.docker.com/get-docker](https://docs.docker.com/get-docker/) |

## Deployment Steps

To streamline deployment and management tasks, this project includes a Makefile with predefined commands for Terraform and Minikube. Using make, you can quickly initialize, apply, destroy, and manage infrastructure without remembering long commands.

Usage Examples:
- Initialize Terraform: make init
- Deploy for a client: make apply CLIENT=meta
- Destroy client infrastructure: make destroy CLIENT=rockstar
- Manage workspaces: make workspace-new CLIENT=netflix
- Start Minikube and enable ingress: make start-minikube && make enable-ingress
For a full list of available commands, run:
```bash
make help
```

### 1. Start Minikube (If Not Running)
```bash
minikube start
```

### 2. Apply Cert-Manager for TLS Certificates
```bash
kubectl apply -f cert-manager.yaml
```

### 3. Enable Ingress Addon for External Access
```bash
minikube addons enable ingress
```

### 4. Initialize Terraform
```bash
terraform init
```

### 5. Create a Workspace for the Client Deployment
```bash
terraform workspace new netflix-prod
```

### 6. Deploy Infrastructure for a Specific Client
```bash
terraform apply -var-file=clients/netflix.tfvars
```
You can also override specific variables dynamically:
```bash
terraform apply -var-file=clients/netflix.tfvars -var="replica_count=2" -var="environment=qa"
```

### 7. Configure Local DNS (Minikube Only)
```bash
echo "$(minikube ip) netflix.example.com" | sudo tee -a /etc/hosts
```

### 8. Access the Deployed Odoo Application
```bash
https://netflix.example.com
```

## Customization

| Variable           | Description                         | Default | Required |
|--------------------|-------------------------------------|---------|----------|
| `client_name`      | Client identifier (Netflix, Meta, Rockstar) | -       | Yes      |
| `domain_name`      | Base domain for ingress             | -       | Yes      |
| `environment`      | Deployment stage (dev/qa/prod)      | -       | Yes      |
| `namespace`        | Kubernetes namespace                | -       | Yes      |
| `replica_count`    | Number of Odoo replicas             | `1`     | No       |

## Notes
- Each client requires a `.tfvars` configuration file in the `clients/` directory.
- Current `.tfvars` configuration file in the `clients/` have a default overwrite for your convenience. These should be edited for later use.
- Terraform workspaces can be used to separate deployments per client.
- Ensure Minikube is running and ingress is enabled before deploying.

## License
This project follows an open-source license. Modify as needed for your organization.