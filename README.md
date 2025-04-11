# ScaleGrid Live Demo

## Assignment:
Create 2 Kubernetes clusters in your preferred cloud platform.
Deploy a single  Postgresql cluster with nodes running in the 2 Kubernetes clusters in a High Availability setup through helm charts ONLY.

## Acceptance Criteria:
### Live demo:
    - Postgresql cluster deployment from your IaC script.
    - Demonstrate the cluster's high availability with cluster level fault tolerance.
All to be done live.

![PostgreSQL HA Architecture](diagram/postgres-ha-architecture-diagram.png)

## Makefile for Terraform, AWS EKS, and Helm Deployment
This Makefile will automate the following tasks:

    - Provision EKS clusters using Terraform
    - Configure kubectl for both EKS clusters
    - Validate nodes
    - Deploy StorageClass and Secrets using Helm
    - Deploy PostgreSQL HA Cluster on both EKS clusters



## How to Use This Makefile
1. Initialize Terraform:

    ```make terraform-init```

2. Apply Terraform Configuration:

    ```make terraform-apply```

3. Configure AWS EKS for kubectl:

    ```make kubeconfig```

4. Validate Kubernetes Nodes:

    ```make validate-nodes```

5. Update Helm Repositories:

    ```make helm-update```

6. Deploy StorageClass on Both Clusters:

    ```make storage-class```

7. Secrets on Both Clusters:

   ``` make secrets```

8. Deploy PostgreSQL HA Cluster:

    ```make deploy```

9. Clean Up Helm Deployments:

  ```make clean```

## Why Use This Makefile?
    ✔ Automates Terraform, AWS CLI, and Helm commands
    ✔ Ensures Idempotency (Re-run without causing issues)
    ✔ Easy to Use (Single command deployment)
    ✔ Enables Multi-Cluster Management


This Makefile fully automates the EKS PostgreSQL HA Cluster deployment across two AWS regions. 🚀