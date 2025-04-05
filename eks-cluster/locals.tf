
locals {
  cluster_names = [
    "${var.project}-eks-${random_string.suffix[0].result}",
    "${var.project}-eks-${random_string.suffix[1].result}"
  ]
}

