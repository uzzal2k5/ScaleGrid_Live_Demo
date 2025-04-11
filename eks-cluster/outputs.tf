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

output "vpc_1_public_route_table_ids" {
  description = "Public route table id"
  value = module.vpc_1.public_route_table_ids
}

output "vpc_1_private_route_table_ids" {
  description = "Private route table id"
  value = module.vpc_1.private_route_table_ids
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

output "vpc_2_public_route_table_ids" {
  description = "Public route table id"
  value = module.vpc_2.public_route_table_ids
}

output "vpc_2_private_route_table_ids" {
  description = "Private route table id"
  value = module.vpc_2.private_route_table_ids
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

# ✅ Outputs for EKS Cluster 2

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


# VPC peering
output "vpc_peering_connection_id" {
  description = "The ID of the VPC peering connection"
  value       = aws_vpc_peering_connection.peer.id
}

output "vpc_peering_connection_status" {
  description = "The status of the VPC peering connection"
  value       = aws_vpc_peering_connection.peer.accept_status
}

output "vpc1_to_vpc2_route_id" {
  description = "Route ID from VPC1 to VPC2"
  value       = aws_route.route_vpc1_to_vpc2.id
}

output "vpc2_to_vpc1_route_id" {
  description = "Route ID from VPC2 to VPC1"
  value       = aws_route.route_vpc2_to_vpc1.id
}

output "peer_accepter_status" {
  description = "Status of the peer accepter"
  value       = aws_vpc_peering_connection_accepter.peer_accept.accept_status
}


output "vpc_peering_info" {
  description = "Complete info of the peering connection"
  value = {
    id     = aws_vpc_peering_connection.peer.id
    status = aws_vpc_peering_connection.peer.requester
    peer_owner_id = aws_vpc_peering_connection.peer.peer_owner_id
    peer_region   = aws_vpc_peering_connection.peer.peer_region
  }
}


output "eks_node_sg_id" {
  description = "Node Security Group ID"
  value = module.eks_1.node_security_group_id
}
