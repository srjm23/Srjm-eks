provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = "eks-study"
      ManagedBy = "Terraform"
      Purpose   = "Terraform state"
    }
  }
}
