# Terraform Project for Multi-Client Deployment

This project deploys a Kubernetes cluster and Odoo application for multiple clients (Netflix, Meta, Rockstar).

## Prerequisites
- Terraform
- Minikube
- kubectl

## Deployment Instructions
1. Before applying Terraform, ensure the Minikube profile is created for your client. Terraform can handle this dynamically if configured:
   ```bash
   minikube start
   ```

2. Apply the cert-manager.yaml:
   ```bash
   kubectl apply -f cert-manager.yaml
   ```

3. Enable Ingress Addon:
   ```bash
   minikube addons enable ingress
   ```

4. Start Terraform:
   ```bash
   terraform init
   ```

5. Create appropriate Workspace for each new cluster you want to create:
   ```bash
   terraform workspace new netflix-prod
   ```

6. Apply Terraform with the appropriate namespace:
   ```bash
   terraform apply -var-file=clients/netflix.tfvars 
   ```
   Or any other .tfvar file in the clients directory. You can change any of the default values by applying
   ```bash
   terraform apply -var-file=clients/netflix.tfvars -var="replica_count=1" -var="qa"
   ```
   You will be prompted to fill the missing variable that is not set to a default, which will be the namespace.
   It will also ask you for the name of the Profile you wish to add it to.

7. Access the Odoo application at https://<domain-name>. Just change the domain name to any on the .tfvars files.

In the future, if more clients are onboarded, you would only need to add new .tfvars in the client folder. The rest should be handled by simply applying with different variables.



