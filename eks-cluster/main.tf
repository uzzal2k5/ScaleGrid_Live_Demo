# Create Security Group in Region 1
module "eks_1" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"
  providers = {
    aws = aws.region1
  }
  cluster_name    = "${var.project}1"
  cluster_version = "1.32"

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    aws-ebs-csi-driver = {
      service_account_role_arn = module.irsa-ebs-csi-region1.iam_role_arn
    }
  }
  vpc_id     = module.vpc_1.vpc_id
  subnet_ids = module.vpc_1.private_subnets

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    one = {
      name = "${module.eks_1.cluster_name}-ng-1"  # Use cluster_name dynamically
      instance_types = ["t3.small"]
      min_size     = 1
      max_size     = 2
      desired_size = 2
      security_group_ids = [aws_security_group.eks_sg_1.id]
    }

  }
  depends_on = [module.vpc_1]  # Ensure VPC is created before EKS
}


# Create Security Group in Region 2
module "eks_2" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"
  providers = {
    aws = aws.region2
  }
  cluster_name    = "${var.project}2"
  cluster_version = "1.32"

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    aws-ebs-csi-driver = {
      service_account_role_arn = module.irsa-ebs-csi-region2.iam_role_arn
    }
  }

  vpc_id     = module.vpc_2.vpc_id  # Correct way to pass the VPC ID
  subnet_ids = module.vpc_2.private_subnets

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    one = {
      name = "${module.eks_2.cluster_name}-ng-1"
      instance_types = ["t3.small"]
      min_size     = 1
      max_size     = 2
      desired_size = 2
      security_group_ids = [aws_security_group.eks_sg_2.id]
    }

  }
  depends_on = [module.vpc_2]  # Ensure VPC is created before EKS
}
