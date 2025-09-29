# 🚀 Portfolio Infra

[![CI](https://github.com/andre-alves5/portfolio-infra/actions/workflows/ci-plan-python.yml/badge.svg)]()
[![Security Scan](https://img.shields.io/badge/IaC-Security-brightgreen)]()
[![Terraform](https://img.shields.io/badge/Terraform-Terragrunt-623CE4)]()

## 📖 Overview
This repository is part of my **DevOps Portfolio Project**, a hands-on showcase of modern cloud-native and DevOps practices.  
It demonstrates how to provision and manage infrastructure using **Terraform + Terragrunt**, implement **multi-environment pipelines**, and enforce **IaC testing and security validation**.

---

## 🏗️ Architecture

```mermaid
flowchart TD
  subgraph Repos
    A1[portfolio-infra (Terraform/Terragrunt)]:::repo
    A2[portfolio-gitops (ArgoCD apps)]:::repo
    A3[backend/frontend repos (Docker images)]:::repo
  end

  subgraph CI/CD
    B1[GitHub Actions\nPlan • Test • Security • Build]:::ci
    B2[OIDC to AWS IAM Role]:::ci
  end

  subgraph IaC Platform (AWS)
    C1[S3 State + DynamoDB Locks]:::aws
    C2[Secure VPC + Subnets (dev/prod)]:::aws
    C3[EKS Cluster (dev/prod)]:::aws
    C4[Karpenter\nController + Provisioners]:::aws
    C5[Ingress Controller (ALB/NGINX)]:::aws
  end

  subgraph GitOps Runtime
    D1[ArgoCD (App-of-Apps)]:::k8s
    D2[Workloads via GitOps]:::k8s
    D3[External Secrets / SOPS]:::k8s
  end

  subgraph Observability & Security
    E1[Datadog\nAPM • Logs • Infra]:::obs
    E2[Prometheus/Grafana/Loki]:::obs
    E3[Checkov • Conftest(OPA) • Trivy • TFLint]:::sec
  end

  %% Flow
  A1 --> B1 -->|plan/apply| B2 --> C2
  A1 --> C1
  C2 --> C3 --> C4 --> C5 --> D2
  A2 --> D1 -->|sync| D2
  A3 -->|build & push| B1 -->|publish images| Registry[(Container Registry)]
  D2 -->|pull images| Registry
  D2 --> E1
  C3 --> E1
  D2 --> E2
  B1 --> E3

  classDef repo fill:#2b3a67,stroke:#fff,color:#fff
  classDef ci fill:#385170,stroke:#fff,color:#fff
  classDef aws fill:#2a7f62,stroke:#fff,color:#fff
  classDef k8s fill:#226089,stroke:#fff,color:#fff
  classDef obs fill:#6d597a,stroke:#fff,color:#fff
  classDef sec fill:#8a5a44,stroke:#fff,color:#fff

