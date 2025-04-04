terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.30.0"  # Use the latest available version
    }
  }
  required_version = ">= 1.3.0"  # Ensure Terraform itself is updated
}
provider "aws" {
  region = var.regions[0]
  alias  = "region1"
}

provider "aws" {
  region = var.regions[1]
  alias  = "region2"
}