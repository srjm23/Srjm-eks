# Amazon EKS com Terraform

Este projeto cria um cluster Amazon EKS na AWS usando Terraform e GitHub Actions.

## Infraestrutura

- VPC `10.0.0.0/16` em duas zonas de disponibilidade.
- Duas sub-redes públicas e duas privadas.
- Internet Gateway, NAT Gateway e tabelas de rotas.
- Cluster EKS `eks-srjm` com endpoint privado e acesso público restrito por CIDR.
- Managed Node Group privado com instâncias Spot `c7i-flex.large`.
- Escala padrão de 2 a 3 nós.
- Add-ons VPC CNI, CoreDNS, kube-proxy e EBS CSI Driver.
- Criptografia de secrets com AWS KMS.
- Logs do EKS e VPC Flow Logs no CloudWatch.
- Roles IAM e provedor OIDC para acesso seguro aos serviços AWS.

- Karpenter e seus CRDs instalados por Helm, com IAM e descoberta de rede configurados pelo Terraform.

## GitHub Actions

O workflow valida e provisiona a infraestrutura:

1. Verifica a formatação do Terraform.
2. Executa análise de segurança com Checkov.
3. Executa `terraform init`, `validate` e `plan`.
4. Em execução manual, permite escolher `apply` ou `destroy`.

A autenticação na AWS utiliza GitHub OIDC, sem chaves de acesso permanentes.

## Configuração necessária

Configure no GitHub:

- Secret `AWS_ROLE_ARN`: role AWS usada pelo GitHub Actions.
- Secret `EKS_PUBLIC_ACCESS_CIDR`: CIDR autorizado no endpoint público do EKS.
- Variable `AWS_REGION`: região AWS, por padrão `us-east-2`.

O state é armazenado de forma criptografada no bucket S3 `eks-sjrm-tfstate`, que deve existir antes da execução da pipeline.

## Provisionamento

Em **Actions > Terraform DevSecOps Deploy > Run workflow**, selecione:

- `apply` para criar ou atualizar a infraestrutura.
- `destroy` para remover os recursos gerenciados pelo Terraform.
