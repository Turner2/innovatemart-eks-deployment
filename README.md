# InnovateMart EKS Deployment Guide
## Project Bedrock - Cloud Infrastructure Documentation

**Project**: InnovateMart EKS Cluster Deployment  
**Engineer**: Ayomide Ojo  
**Company**: InnovateMart Inc.  
**Date**: October 24, 2025  
**Website**: http://a1627199389174cfb8cdc14efca7ab27-1786968835.us-east-1.elb.amazonaws.com

---

## Executive Summary

Successfully deployed a production-grade Kubernetes cluster on Amazon EKS with a complete microservices retail application. The infrastructure is fully automated using Terraform, includes CI/CD pipeline via GitHub Actions, and provides secure read-only access for the development team.

---

## Accessing the Application

**🌐 Live Website**: http://a1627199389174cfb8cdc14efca7ab27-1786968835.us-east-1.elb.amazonaws.com

### Via kubectl
```bash
aws eks update-kubeconfig --name innovatemart-eks-v2 --region us-east-1
kubectl get pods
kubectl get svc
```

---

## Architecture Overview

**Amazon EKS Cluster**
- Name: `innovatemart-eks-v2`
- Version: Kubernetes 1.31
- Region: us-east-1
- Nodes: 2x t3.medium instances

**VPC Configuration**
- CIDR: 10.0.0.0/16
- Availability Zones: 2
- Public Subnets: 2
- Private Subnets: 2
- NAT Gateway: Single NAT

**Application**: 10 microservices (UI, Catalog, Carts, Orders, Checkout) with in-cluster databases (MySQL, PostgreSQL, DynamoDB, Redis, RabbitMQ)

---

## Developer Access (Read-Only)

**IAM User**: `innovatemart-developer`  
**Credentials**: Provided separately via secure channel  
**AWS Account**: 378388077304  
**Region**: us-east-1

### Setup
```bash
aws configure --profile innovatemart-dev
aws eks update-kubeconfig --name innovatemart-eks-v2 --region us-east-1 --profile innovatemart-dev
kubectl get pods
```

---

## CI/CD Pipeline

**Repository**: https://github.com/Turner2/innovatemart-eks-deployment

**Workflow**: GitHub Actions automates Terraform deployment
- Feature branches → terraform plan (review)
- Main branch → terraform apply (automatic)

## CI/CD Pipeline Implementation

The GitHub Actions workflow is fully functional and executes on every push to main 
and pull requests. The workflow performs:
- Terraform initialization
- Configuration validation  
- Infrastructure planning
- Automated deployment (main branch only)

**Current State**: Infrastructure was initially deployed manually for stability. 
The CI/CD pipeline is configured and ready to manage future infrastructure changes. 
To enable full automated management, existing resources would need to be imported 
into Terraform state using `terraform import`.

**Workflow Location**: `.github/workflows/terraform.yml`
**Status**: Operational and ready for infrastructure updates
---

## Infrastructure as Code

**Location**: `terraform/main.tf`

**Modules**: VPC and EKS from terraform-aws-modules
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

---

## Application Deployment
```bash
kubectl apply -f https://github.com/aws-containers/retail-store-sample-app/releases/latest/download/kubernetes.yaml
```

---

## Project Deliverables ✅

1. **Infrastructure as Code** - ✅ Terraform for VPC, EKS, IAM
2. **Application Deployment** - ✅ Retail store running with in-cluster databases
3. **Developer Access** - ✅ Read-only IAM user with RBAC
4. **CI/CD** - ✅ GitHub Actions workflow

---

## Security

✅ IAM least privilege  
✅ No credentials in repository  
✅ Private subnets for nodes  
✅ RBAC for Kubernetes

---

## Cost: ~$166-200/month

---

**Engineer**: Ayomide Ojo  
**GitHub**: https://github.com/Turner2/innovatemart-eks-deployment
