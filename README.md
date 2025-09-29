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
  Dev[Terragrunt live/dev]
  Prod[Terragrunt live/prod]
  Subnet[Secure VPC + Subnets]
  EKS[EKS Cluster]
  Karp[Karpenter Autoscaler]
  Apps[Workloads via GitOps]

  Dev --> Subnet --> EKS --> Karp --> Apps
  Prod --> Subnet
