# Allow inbound access to PostgreSQL (default port 5432) from the EKS1 & EKS2 nodes
# Security Group for EKS Cluster 1 in Region 1
resource "aws_security_group" "eks_sg_1" {
  provider = aws.region1
  name        = "${var.project}1-sg"
  description = "Security Group for EKS Cluster 1"
  vpc_id = module.vpc_1.vpc_id
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "${var.project}1-sg"
  }
}

# Security Group for EKS Cluster 2 in Region 2
resource "aws_security_group" "eks_sg_2" {
  provider = aws.region2
  name        = "${var.project}2-sg"
  description = "Security Group for EKS Cluster 2"
  vpc_id = module.vpc_2.vpc_id
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "${var.project}2-sg"
  }
}


resource "aws_security_group_rule" "allow_eks2_to_eks1_postgresql" {
  provider = aws.region1
  type        = "ingress"
  from_port   = 5432
  to_port     = 5432
  protocol    = "tcp"
  security_group_id = aws_security_group.eks_sg_1.id
  # source_security_group_id = aws_security_group.eks_sg_2.id
  cidr_blocks = [var.vpc_cidr_blocks["vpc_2"]]
}


resource "aws_security_group_rule" "allow_eks1_to_eks2_postgresql" {
  provider = aws.region2
  type        = "ingress"
  from_port   = 5432
  to_port     = 5432
  protocol    = "tcp"
  security_group_id = aws_security_group.eks_sg_2.id
  # source_security_group_id = aws_security_group.eks_sg_1.id
  cidr_blocks = [var.vpc_cidr_blocks["vpc_1"]]
}


