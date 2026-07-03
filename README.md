# EKS com Terraform

Infraestrutura como código para provisionar um cluster Amazon EKS na AWS, com
rede VPC, grupos de nós, IAM, add-ons do cluster e Karpenter.

## Pré-requisitos

- Terraform 1.8 ou superior
- AWS CLI autenticada
- Bucket S3 e tabela DynamoDB previamente criados para o estado remoto
- Uma role IAM com OIDC para execução pelo GitHub Actions

## Execução local

```bash
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan
terraform apply
```

Os principais valores podem ser alterados em `variables.tf`, incluindo região,
nome do cluster, versão do Kubernetes, redes e capacidade dos nós.

## Pipeline

O workflow `.github/workflows/terraform.yml` executa:

1. verificação de formatação e análise de segurança com Checkov;
2. validação e geração do `terraform plan`;
3. armazenamento do plano como artefato;
4. `terraform apply` somente após aprovação no environment `production`.

Configure no GitHub o secret `AWS_ROLE_ARN` e as seguintes variables:

| Variável | Descrição |
| --- | --- |
| `AWS_REGION` | Região AWS, por exemplo `us-east-2` |
| `TF_STATE_BUCKET` | Bucket S3 usado pelo estado remoto |
| `TF_STATE_KEY` | Caminho do state, por exemplo `eks/terraform.tfstate` |
| `TF_LOCK_TABLE` | Tabela DynamoDB usada para locking |

Em **Settings > Environments > production**, configure os revisores obrigatórios
para impedir o apply sem aprovação.
