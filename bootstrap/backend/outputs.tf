output "bucket_name" {
  description = "Nome a configurar na variável AWS_TF_STATE_BUCKET do GitHub."
  value       = aws_s3_bucket.terraform_state.id
}
