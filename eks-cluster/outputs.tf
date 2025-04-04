# VPC1 OUTPUT
output "vpc1_ids" {
  description = "VPC IDs for each region"
  value       = module.vpc_1.vpc_id
}

output "vpc1_private_subnets" {
  description = "Private subnets in each region"
  value       = module.vpc_1.private_subnets
}
output "vpc1_public_subnets" {
  value = module.vpc_1.public_subnets  # ✅ Access directly if it's a single module
}
# VPC2 OUTPUT
output "vpc2_ids" {
  description = "VPC IDs for each region"
  value       = module.vpc_2.vpc_id
}

output "vpc2_private_subnets" {
  description = "Private subnets in each region"
  value       = module.vpc_2.private_subnets
}
output "vpc2_public_subnets" {
  value = module.vpc_2.public_subnets  # ✅ Access directly if it's a single module
}
# Security Group
output "eks_sg_1_id" {
  value = aws_security_group.eks_sg_1.id
}

output "eks_sg_2_id" {
  value = aws_security_group.eks_sg_2.id
}

# EKS Cluster 1 OUTPUT
output "eks_1_cluster_name" {
  description = "The name of the first EKS cluster"
  value       = module.eks_1.cluster_name
}

output "eks_1_cluster_endpoint" {
  description = "EKS Cluster 1 API Server endpoint"
  value       = module.eks_1.cluster_endpoint
}

output "eks_1_oidc_provider" {
  description = "OIDC provider URL for EKS Cluster 1"
  value       = module.eks_1.oidc_provider
}

output "eks_1_node_groups" {
  description = "Node groups for EKS Cluster 1"
  value       = module.eks_1.eks_managed_node_groups
}

output "eks_1_vpc_id" {
  description = "VPC ID for EKS Cluster 1"
  value       = module.vpc_1.vpc_id
}

output "eks_1_subnets" {
  description = "Private subnets for EKS Cluster 1"
  value       = module.vpc_1.private_subnets
}

# Outputs for EKS Cluster 2

output "eks_2_cluster_name" {
  description = "The name of the second EKS cluster"
  value       = module.eks_2.cluster_name
}

output "eks_2_cluster_endpoint" {
  description = "EKS Cluster 2 API Server endpoint"
  value       = module.eks_2.cluster_endpoint
}

output "eks_2_oidc_provider" {
  description = "OIDC provider URL for EKS Cluster 2"
  value       = module.eks_2.oidc_provider
}

output "eks_2_node_groups" {
  description = "Node groups for EKS Cluster 2"
  value       = module.eks_2.eks_managed_node_groups
}

output "eks_2_vpc_id" {
  description = "VPC ID for EKS Cluster 2"
  value       = module.vpc_2.vpc_id
}

output "eks_2_subnets" {
  description = "Private subnets for EKS Cluster 2"
  value       = module.vpc_2.private_subnets
}

# IAM Role Outputs for EBS CSI Driver
output "eks_1_ebs_csi_role_arn" {
  description = "IAM Role ARN for EBS CSI Driver in EKS Cluster 1"
  value       = module.irsa-ebs-csi-region1.iam_role_arn
}

output "eks_2_ebs_csi_role_arn" {
  description = "IAM Role ARN for EBS CSI Driver in EKS Cluster 2"
  value       = module.irsa-ebs-csi-region2.iam_role_arn
}

