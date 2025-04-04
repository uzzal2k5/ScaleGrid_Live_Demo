# https://aws.amazon.com/blogs/containers/amazon-ebs-csi-driver-is-now-generally-available-in-amazon-eks-add-ons/
# Define IAM Policy for EBS CSI Driver
data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

# Create IAM Role for EBS CSI in Region 1
module "irsa-ebs-csi-region1" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.39.0"

  providers = {
    aws = aws.region1  # Use region1 provider
  }

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${var.project}-region1"
  provider_url                  = module.eks_1.oidc_provider  # OIDC Provider for EKS_1
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}

# Create IAM Role for EBS CSI in Region 2
module "irsa-ebs-csi-region2" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.39.0"

  providers = {
    aws = aws.region2  # Use region2 provider
  }

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${var.project}-region2"
  provider_url                  = module.eks_2.oidc_provider  # OIDC Provider for EKS_2
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}
