terraform {
  backend "s3" {
    bucket         = var.name_s3_backend
    key            = "eks/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = var.name_s3_backend
    encrypt        = true
  }
}

terraform {
  backend "s3" {}
}