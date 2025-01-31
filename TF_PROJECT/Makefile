CLIENT ?= netflix
TFVARS_FILE ?= clients/$(CLIENT).tfvars
WORKSPACE ?= $(CLIENT)-prod
DOMAIN ?= $(CLIENT).example.com

init:
	terraform init

plan:
	terraform plan -var-file=$(TFVARS_FILE)

apply:
	terraform apply -var-file=$(TFVARS_FILE) -auto-approve

destroy:
	terraform destroy -var-file=$(TFVARS_FILE) -auto-approve

workspace-new:
	terraform workspace new $(WORKSPACE)

workspace-select:
	terraform workspace select $(WORKSPACE)

list-workspaces:
	terraform workspace list

status:
	terraform workspace show

start-minikube:
	minikube start

enable-ingress:
	minikube addons enable ingress

apply-cert-manager:
	kubectl apply -f cert-manager.yaml

stop-minikube:
	minikube stop

clean-minikube:
	minikube delete && minikube start

add-hosts:
	echo "$$(minikube ip) $(DOMAIN)" | sudo tee -a /etc/hosts

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  init              Initialize Terraform"
	@echo "  plan              Plan Terraform changes"
	@echo "  apply             Apply Terraform changes"
	@echo "  destroy           Destroy Terraform resources"
	@echo "  workspace-new     Create a new Terraform workspace"
	@echo "  workspace-select  Select a Terraform workspace"
	@echo "  list-workspaces   List all Terraform workspaces"
	@echo "  status            Show current Terraform workspace"
	@echo "  start-minikube    Start Minikube"
	@echo "  enable-ingress    Enable Ingress in Minikube"
	@echo "  apply-cert-manager Apply Cert Manager in Minikube"
	@echo "  stop-minikube     Stop Minikube"
	@echo "  clean-minikube    Delete and start Minikube"
	@echo "  add-hosts         Add Minikube IP to /etc/hosts"

.PHONY: init plan apply destroy workspace-new workspace-select list-workspaces status \
        start-minikube enable-ingress apply-cert-manager stop-minikube clean-minikube add-hosts
