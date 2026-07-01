terraform {
  required_version = ">= 1.8.0"

  backend "s3" {}

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.4"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.37"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }

    time = {
      source  = "hashicorp/time"
      version = "~> 0.13"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }

  }
}
