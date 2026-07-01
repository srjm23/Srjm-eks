# Bootstrap do backend Terraform

Este módulo cria o bucket S3 usado pelo estado do módulo principal. Execute-o uma
vez antes do workflow, pois um backend não consegue criar o próprio bucket.

```bash
terraform -chdir=bootstrap/backend init
terraform -chdir=bootstrap/backend apply
terraform -chdir=bootstrap/backend output -raw bucket_name
```

Cadastre o valor retornado no GitHub em **Settings > Secrets and variables >
Actions > Variables**, com o nome `AWS_TF_STATE_BUCKET`.

O backend principal usa versionamento e lock nativo do S3 (`use_lockfile`), sem
necessidade de tabela DynamoDB.
