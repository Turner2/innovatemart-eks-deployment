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

## Table of Contents
1. [Architecture Overview](#architecture-overview)
2. [Accessing the Application](#accessing-the-application)
3. [Developer Access (Read-Only)](#developer-access-read-only)
4. [CI/CD Pipeline](#cicd-pipeline)
5. [Infrastructure as Code](#infrastructure-as-code)

---

## Architecture Overview

### Infrastructure Components

**Amazon EKS Cluster**
- **Name**: `innovatemart-eks-v2`
- **Version**: Kubernetes 1.31
- **Region**: us-east-1
- **Nodes**: 2x t3.medium instances
- **Endpoint**: Public access enabled
- **IRSA**: Enabled for service accounts

**VPC Configuration**
- **CIDR**: 10.0.0.0/16
- **Availability Zones**: 2 (us-east-1a, us-east-1b)
- **Public Subnets**: 2 subnets (10.0.101.0/24, 10.0.102.0/24)
- **Private Subnets**: 2 subnets (10.0.1.0/24, 10.0.2.0/24)
- **NAT Gateway**: Single NAT for cost optimization
- **Internet Gateway**: Enabled for public access

**Application Architecture**

The retail store consists of 10 microservices running in Kubernetes:

| Service | Purpose | Database |
|---------|---------|----------|
| **ui** | Frontend web interface | - |
| **catalog** | Product catalog | MySQL |
| **carts** | Shopping cart | DynamoDB |
| **orders** | Order processing | PostgreSQL + RabbitMQ |
| **checkout** | Checkout process | Redis |

All databases run as containers within the EKS cluster (in-cluster dependencies as per core requirements).

---

## Accessing the Application

### Live Application URL

**🌐 Website**: http://a1627199389174cfb8cdc14efca7ab27-1786968835.us-east-1.elb.amazonaws.com

The application is accessible via AWS Elastic Load Balancer and serves the InnovateMart retail store interface.

### Via kubectl

**Step 1: Configure kubectl**
```bash
aws eks update-kubeconfig --name innovatemart-eks-v2 --region us-east-1
```

**Step 2: Verify Application Health**
```bash
kubectl get pods
kubectl get svc
kubectl get svc ui
```

---

## Developer Access (Read-Only)

### IAM User Credentials

A dedicated read-only IAM user has been created for the development team.

**Username**: `innovatemart-developer`  
**Access Key ID**: `[Provided separately via secure channel]`  
**Secret Access Key**: `[Provided separately via secure channel]`  
**AWS Account**: 378388077304  
**Region**: us-east-1

### Setup Instructions

**1. Configure AWS CLI**
```bash
aws configure --profile innovatemart-dev
# Enter credentials when prompted
```

**2. Configure kubectl**
```bash
aws eks update-kubeconfig --name innovatemart-eks-v2 --region us-east-1 --profile innovatemart-dev
```

**3. Test Access**

**✅ Allowed Operations**: get, list, watch, logs  
**❌ Forbidden Operations**: delete, apply, edit, scale

---

## CI/CD Pipeline

### Overview

Infrastructure deployment is automated using GitHub Actions with a GitFlow branching strategy.

**Repository**: https://github.com/Turner2/innovatemart-eks-deployment

### Workflow Configuration

**File**: `.github/workflows/terraform.yml`

**Trigger Events**:
- Push to `main` branch (changes in `terraform/` directory)
- Pull requests to `main` branch

**Branching Strategy**:
- Feature branches → terraform plan (review)
- Main branch → terraform apply (automatic)

---

## Infrastructure as Code

### Terraform Configuration

All infrastructure is version-controlled and defined in Terraform.

**Location**: `terraform/main.tf`

**Key Modules**:
- VPC Module: `terraform-aws-modules/vpc/aws ~> 5.0`
- EKS Module: `terraform-aws-modules/eks/aws ~> 20.0`

### Terraform Commands
```bash
cd terraform
terraform init
terraform validate
terraform plan
terraform apply
```

---

## Application Deployment

### Retail Store Sample App

**Deployment Command**:
```bash
kubectl apply -f https://github.com/aws-containers/retail-store-sample-app/releases/latest/download/kubernetes.yaml
```

### Services Deployed

- `ui` - Frontend
- `catalog` - Product catalog with MySQL
- `carts` - Shopping cart with DynamoDB
- `orders` - Order processing with PostgreSQL and RabbitMQ
- `checkout` - Checkout with Redis

---

## Security Best Practices

✅ Read-only developer user (least privilege)  
✅ No hardcoded credentials in repository  
✅ GitHub Secrets for CI/CD  
✅ Worker nodes in private subnets  
✅ RBAC for Kubernetes access

---

## Monitoring

**Cluster Health**:
```bash
kubectl get nodes
kubectl get pods
kubectl logs <pod-name>
```

---

## Cost Optimization

**Estimated Monthly Costs**: ~$166-200/month
- EKS Control Plane: ~$73/month
- 2x t3.medium EC2: ~$60/month
- NAT Gateway: ~$33/month

---

## Project Deliverables - All Complete ✅

**1. Infrastructure as Code**
- ✅ Terraform for VPC, EKS, IAM
- ✅ Version controlled in Git

**2. Application Deployment**
- ✅ Retail store app deployed
- ✅ In-cluster databases
- ✅ LoadBalancer accessible

**3. Developer Access**
- ✅ Read-only IAM user
- ✅ Kubernetes RBAC configured

**4. CI/CD Automation**
- ✅ GitHub Actions workflow
- ✅ GitFlow branching strategy

---

## Conclusion

Project Bedrock successfully delivered a production-ready Kubernetes infrastructure on AWS EKS.

**InnovateMart retail application**: http://a1627199389174cfb8cdc14efca7ab27-1786968835.us-east-1.elb.amazonaws.com

---

## Contact

**Cloud DevOps Engineer**: Ayomide Ojo  
**Project**: InnovateMart Project Bedrock  
**GitHub**: https://github.com/Turner2/innovatemart-eks-deployment  
**Date**: October 24, 2025
