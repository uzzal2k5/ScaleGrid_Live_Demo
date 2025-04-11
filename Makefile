.PHONY: all terraform-init terraform-apply kubeconfig validate-nodes helm-update storage-class secrets deploy clean

# Variables
PROJECT=eks
TF_DIR=eks-cluster
EKS_CLUSTER_1=eks-cluster-1
EKS_CLUSTER_2=eks-cluster-2
REGION_1=us-east-1
REGION_2=us-east-2
NAMESPACE=database
TF_LOG=DEBUG

# Run all steps
all: terraform-init terraform-apply kubeconfig validate-nodes helm-update storage-class secrets deploy

# Initialize Terraform
terraform-init:
	@echo "Initializing Terraform in directory: $(TF_DIR)"
	terraform -chdir=$(TF_DIR) init --reconfigure
	@echo "Validating Terraform configuration..."
	terraform -chdir=$(TF_DIR) validate
	@echo "Planning Terraform changes..."
	terraform -chdir=$(TF_DIR) plan
# Apply Terraform Configuration
terraform-apply:
	TF_LOG=$(TF_LOG) terraform -chdir=$(TF_DIR) apply -auto-approve 2> terraform-debug.log

# Configure AWS EKS kubeconfig
kubeconfig:
	@echo "Updating kubeconfig for EKS Cluster 1: $(EKS_CLUSTER_1) in $(REGION_1)"
	aws eks update-kubeconfig --region $(REGION_1) --name $(EKS_CLUSTER_1) --alias $(EKS_CLUSTER_1)
	@echo "Updating kubeconfig for EKS Cluster 2: $(EKS_CLUSTER_2) in $(REGION_2)"
	aws eks update-kubeconfig --region $(REGION_2) --name $(EKS_CLUSTER_2) --alias $(EKS_CLUSTER_2)

# Validate Kubernetes Nodes
validate-nodes:
	@echo "Switching to context for EKS Cluster 1: $(EKS_CLUSTER_1)"
	@kubectl config use-context $(EKS_CLUSTER_1) || { echo "Failed to switch to context $(EKS_CLUSTER_1)"; exit 1; }
	@echo "Getting nodes for $(EKS_CLUSTER_1)"
	@kubectl get nodes -o wide || { echo "Failed to fetch nodes from $(EKS_CLUSTER_1)"; exit 1; }

	@echo "Switching to context for EKS Cluster 2: $(EKS_CLUSTER_2)"
	@kubectl config use-context $(EKS_CLUSTER_2) || { echo "Failed to switch to context $(EKS_CLUSTER_2)"; exit 1; }
	@echo "Getting nodes for $(EKS_CLUSTER_2)"
	@kubectl get nodes -o wide || { echo "Failed to fetch nodes from $(EKS_CLUSTER_2)"; exit 1; }

# Update Helm Repositories
helm-update:
	@echo "Adding Bitnami Helm repository..."
	helm repo add bitnami https://charts.bitnami.com/bitnami || true
	@echo "Updating Helm repositories..."
	helm repo update

# Deploy StorageClass on both EKS clusters
storage-class:
	@echo "Switching to context $(EKS_CLUSTER_1) and installing storage-class..."
	kubectl config use-context $(EKS_CLUSTER_1)
	helm install storage-class ./storage-class --namespace $(NAMESPACE) --create-namespace

	@echo "Switching to context $(EKS_CLUSTER_2) and installing storage-class..."
	kubectl config use-context $(EKS_CLUSTER_2)
	helm install storage-class ./storage-class --namespace $(NAMESPACE) --create-namespace

# Deploy Secrets on both EKS clusters
postgres-secrets:
	@echo "Switching to context $(EKS_CLUSTER_1) and installing postgres-secrets..."
	kubectl config use-context $(EKS_CLUSTER_1)
	helm upgrade --install postgres-secrets ./postgres-secrets --namespace $(NAMESPACE) --create-namespace

	@echo "Switching to context $(EKS_CLUSTER_2) and installing postgres-secrets..."
	kubectl config use-context $(EKS_CLUSTER_2)
	helm upgrade --install postgres-secrets ./postgres-secrets --namespace $(NAMESPACE) --create-namespace

# Deploy PostgreSQL HA Cluster on both EKS clusters
deploy:
	@echo "Switching to context $(EKS_CLUSTER_1) and installing PostgreSQL Master (pg-cluster-1)..."
	kubectl config use-context $(EKS_CLUSTER_1)
	helm install pg-cluster-1 bitnami/postgresql-ha -f ./postgres-cluster/postgres-master-values.yaml --namespace $(NAMESPACE) --create-namespace

	@echo "Switching to context $(EKS_CLUSTER_2) and installing PostgreSQL Replica (pg-cluster-2)..."
	kubectl config use-context $(EKS_CLUSTER_2)
	helm install pg-cluster-2 bitnami/postgresql-ha -f ./postgres-cluster/postgres-replica-values.yaml --namespace $(NAMESPACE) --create-namespace

# Cleanup (Uninstall Helm releases)
#The - prefix before each helm uninstall makes sure make continues even if a command fails (e.g., if the release doesn't exist).
clean:
	@echo "Switching to context $(EKS_CLUSTER_1) and uninstalling resources..."
	kubectl config use-context $(EKS_CLUSTER_1)
	-helm uninstall pg-cluster-1 --namespace $(NAMESPACE) || true
	-helm uninstall postgres-secrets --namespace $(NAMESPACE) || true
	-helm uninstall storage-class --namespace $(NAMESPACE) || true

	@echo "Switching to context $(EKS_CLUSTER_2) and uninstalling resources..."
	kubectl config use-context $(EKS_CLUSTER_2)
	-helm uninstall pg-cluster-2 --namespace $(NAMESPACE) || true
	-helm uninstall postgres-secrets --namespace $(NAMESPACE) || true
	-helm uninstall storage-class --namespace $(NAMESPACE) || true