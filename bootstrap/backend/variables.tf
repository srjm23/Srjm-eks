variable "aws_region" {
  description = "Região do bucket que armazenará o estado do Terraform."
  type        = string
  default     = "us-east-2"
}

variable "bucket_prefix" {
  description = "Prefixo do nome globalmente único do bucket."
  type        = string
  default     = "srjm-eks-tfstate"
}
