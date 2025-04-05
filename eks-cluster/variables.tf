variable "project" {
  description = "Project"
  type        = string
  default     = "eks"
}

variable "regions" {
  description = "AWS regions to deploy EKS"
  type        = list(string)
  default     = ["us-east-1", "us-east-2"]
}
variable "vpc_cidr_blocks" {
  description = "VPC CIDR blocks for each region"
  type = map(string)
  default = {
    vpc_1 = "10.10.0.0/16"
    vpc_2 = "10.20.0.0/16"
  }
}

# Route Table vpc1 , vpc2
variable "vpc1_route_table_id" {}
variable "vpc2_route_table_id" {}

