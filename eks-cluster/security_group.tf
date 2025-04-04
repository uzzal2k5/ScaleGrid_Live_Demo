# Security Group for EKS Cluster 1 in Region 1
resource "aws_security_group" "eks_sg_1" {
  provider = aws.region1
  name        = "eks-cluster-1-sg"
  description = "Security Group for EKS Cluster 1"
}

# Security Group for EKS Cluster 2 in Region 2
resource "aws_security_group" "eks_sg_2" {
  provider = aws.region2
  name        = "eks-cluster-2-sg"
  description = "Security Group for EKS Cluster 2"
}


resource "aws_security_group_rule" "allow_eks2_to_eks1_postgresql" {
  provider = aws.region1
  type        = "ingress"
  from_port   = 5432
  to_port     = 5432
  protocol    = "tcp"
  security_group_id = aws_security_group.eks_sg_1.id
  source_security_group_id = aws_security_group.eks_sg_2.id
}


resource "aws_security_group_rule" "allow_eks1_to_eks2_postgresql" {
  provider = aws.region2
  type        = "ingress"
  from_port   = 5432
  to_port     = 5432
  protocol    = "tcp"
  security_group_id = aws_security_group.eks_sg_2.id
  source_security_group_id = aws_security_group.eks_sg_1.id
}


