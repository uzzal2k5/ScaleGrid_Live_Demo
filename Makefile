.PHONY: all terraform-init terraform-apply kubeconfig validate-nodes helm-update storage-class secrets deploy clean

# Variables
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
	terraform -chdir=$(TF_DIR) init --reconfigure
	terraform -chdir=$(TF_DIR) validate
	terraform -chdir=$(TF_DIR) plan

# Apply Terraform Configuration
terraform-apply:
	TF_LOG=$(TF_LOG) terraform -chdir=$(TF_DIR) apply -auto-approve 2> terraform-debug.log

# Configure AWS EKS kubeconfig
kubeconfig:
	aws eks update-kubeconfig --region $(REGION_1) --name EKS1 --alias $(EKS_CLUSTER_1)
	aws eks update-kubeconfig --region $(REGION_2) --name EKS2 --alias $(EKS_CLUSTER_2)

# Validate Kubernetes Nodes
validate-nodes:
	kubectl config use-context $(EKS_CLUSTER_1)
	kubectl get nodes -o wide
	kubectl config use-context $(EKS_CLUSTER_2)
	kubectl get nodes -o wide

# Update Helm Repositories
helm-update:
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo update

# Deploy StorageClass on both EKS clusters
storage-class:
	kubectl config use-context $(EKS_CLUSTER_1)
	helm install storage-class ./storage-class --namespace $(NAMESPACE) --create-namespace
	kubectl config use-context $(EKS_CLUSTER_2)
	helm install storage-class ./storage-class --namespace $(NAMESPACE) --create-namespace

# Deploy Secrets on both EKS clusters
secrets:
	kubectl config use-context $(EKS_CLUSTER_1)
	helm install postgres-secrets ./postgres-secrets --namespace $(NAMESPACE) --create-namespace
	kubectl config use-context $(EKS_CLUSTER_2)
	helm install postgres-secrets ./postgres-secrets --namespace $(NAMESPACE) --create-namespace

# Deploy PostgreSQL HA Cluster on both EKS clusters
deploy:
	kubectl config use-context $(EKS_CLUSTER_1)
	helm install pg-cluster-1 bitnami/postgresql-ha -f ./postgresql-cluster/postgres-values.yaml --namespace $(NAMESPACE) --create-namespace
	kubectl config use-context $(EKS_CLUSTER_2)
	helm install pg-cluster-2 bitnami/postgresql-ha -f ./postgresql-cluster/postgresql-replica-values.yaml --namespace $(NAMESPACE) --create-namespace

# Cleanup (Uninstall Helm releases)
clean:
	kubectl config use-context $(EKS_CLUSTER_1)
	helm uninstall pg-cluster-1 --namespace $(NAMESPACE) || true
	helm uninstall postgres-secrets --namespace $(NAMESPACE) || true
	helm uninstall storage-class --namespace $(NAMESPACE) || true

	kubectl config use-context $(EKS_CLUSTER_2)
	helm uninstall pg-cluster-2 --namespace $(NAMESPACE) || true
	helm uninstall postgres-secrets --namespace $(NAMESPACE) || true
	helm uninstall storage-class --namespace $(NAMESPACE) || true
