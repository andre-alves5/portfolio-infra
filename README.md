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
  TG_DEV[Terragrunt live/dev] --> VPC[Secure VPC + Subnets]
  TG_PROD[Terragrunt live/prod] --> VPC
  VPC --> EKS[EKS Cluster]
  EKS --> KARP[Karpenter (Controller + Provisioners)]
  KARP --> INGRESS[Ingress Controller]
  INGRESS --> WORKLOADS[Workloads via ArgoCD (GitOps)]

  subgraph Controls
    CI[GitHub Actions + OIDC] -->|plan/apply| EKS
    STATE[S3 + DynamoDB (TF state/locks)] --> TG_DEV
    STATE --> TG_PROD
    POL[Checkov • Conftest(OPA) • Trivy • TFLint] --> CI
    OBS[Datadog APM/Logs + Prom/Grafana/Loki] --> EKS
  end

