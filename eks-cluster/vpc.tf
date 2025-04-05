# VPC 1
module "vpc_1" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"
  providers = {
    aws = aws.region1
  }

  name = "${var.project}-vpc1"
  cidr = var.vpc_cidr_blocks["vpc_1"]
  azs             = slice(data.aws_availability_zones.available_vpc1.names, 0, 2)
  private_subnets = [cidrsubnet(var.vpc_cidr_blocks["vpc_1"], 8, 1), cidrsubnet(var.vpc_cidr_blocks["vpc_1"], 8, 2)]
  public_subnets  = [cidrsubnet(var.vpc_cidr_blocks["vpc_1"], 8, 101), cidrsubnet(var.vpc_cidr_blocks["vpc_1"], 8, 102)]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}
# VPC 2
module vpc_2 {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"
  providers = {
    aws = aws.region2
  }


  name = "${var.project}-vpc2"
  cidr = var.vpc_cidr_blocks["vpc_2"]
  azs             = slice(data.aws_availability_zones.available_vpc2.names, 0, 2)
  private_subnets = [cidrsubnet(var.vpc_cidr_blocks["vpc_2"], 8, 1), cidrsubnet(var.vpc_cidr_blocks["vpc_2"], 8, 2)]
  public_subnets  = [cidrsubnet(var.vpc_cidr_blocks["vpc_2"], 8, 101), cidrsubnet(var.vpc_cidr_blocks["vpc_2"], 8, 102)]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}