# InnovateMart EKS Deployment

Enterprise-grade deployment of the [AWS Retail Store Sample App](https://github.com/aws-containers/retail-store-sample-app) on Amazon EKS with managed AWS database services.

## 🎯 Project Overview

This project deploys the AWS Retail Store Sample App (a cloud-native microservices demo) on Amazon EKS with production-grade enhancements:

- **Source Application:** [aws-containers/retail-store-sample-app](https://github.com/aws-containers/retail-store-sample-app)
- **8 microservices** running on Kubernetes
- **Managed AWS databases** replacing in-cluster databases (RDS PostgreSQL, RDS MySQL, DynamoDB)
- **Public internet access** via AWS Classic Load Balancer
- **Infrastructure as Code** using Terraform
- **IAM Roles for Service Accounts (IRSA)** for secure AWS access

**🌐 Live Application URL:**
```
http://a07117e2afc204e8881978218ae8b3f7-1142816972.us-east-1.elb.amazonaws.com
```

---

## 🏗️ Architecture

### Compute Layer
- **EKS Cluster:** v1.28.15-eks-113cf36
- **Nodes:** 2x t3.medium instances
- **Availability Zones:** us-east-1a, us-east-1b
- **Region:** us-east-1

### Database Layer (✅ Bonus 1 - Enhanced from Original)

**Original App Used:** In-cluster StatefulSets for all databases

**Enhanced With:**
- **RDS PostgreSQL** → Orders service database
  - Instance: `innovatemart-orders-pg`
  - **Benefit:** Automated backups, point-in-time recovery, managed updates
  
- **RDS MySQL** → Catalog service database
  - Instance: `innovatemart-catalog-mysql`
  - **Benefit:** Multi-AZ availability, automated patching, performance insights
  
- **DynamoDB** → Carts service (with IAM IRSA - no credentials!)
  - Table: `innovatemart-carts`
  - IAM Role: `innovatemart-eks-cluster-carts-dynamodb-role`
  - **Benefit:** Serverless, auto-scaling, pay-per-request pricing

### Networking Layer (✅ Bonus 2 - Production-Ready Access)
- **VPC:** Custom VPC with public/private subnets
- **Classic Load Balancer:** Public internet access to application
- **AWS Load Balancer Controller:** Installed and configured
- **Security Groups:** Configured for least privilege access

---

## 📦 Application Components

Based on [AWS Retail Store Sample App](https://github.com/aws-containers/retail-store-sample-app):

| Service | Description | Original Database | Enhanced Database | Status |
|---------|-------------|-------------------|-------------------|--------|
| **UI** | React frontend | - | - | ✅ Running |
| **Catalog** | Product catalog API | MySQL StatefulSet | **RDS MySQL** | ✅ Running |
| **Orders** | Order processing | PostgreSQL StatefulSet | **RDS PostgreSQL** | ✅ Running |
| **Carts** | Shopping cart API | DynamoDB Local | **DynamoDB (AWS)** | ✅ Running |
| **Checkout** | Checkout process | Redis StatefulSet | Redis (in-cluster) | ✅ Running |
| **Assets** | Static assets server | - | - | ✅ Running |
| **RabbitMQ** | Message queue | RabbitMQ StatefulSet | RabbitMQ (in-cluster) | ✅ Running |

---

## 🚀 Quick Start

### Prerequisites
- AWS CLI configured with credentials
- Terraform >= 1.6.0
- kubectl >= 1.28
- Helm >= 3.0

### Deploy in 5 Steps

```bash
# 1. Clone repository
git clone https://github.com/Turner2/innovatemart-eks-deployment.git
cd innovatemart-eks-deployment

# 2. Deploy infrastructure
cd terraform
terraform init
terraform apply -auto-approve

# 3. Configure kubectl
aws eks update-kubeconfig --region us-east-1 --name innovatemart-eks-cluster

# 4. Create secrets
kubectl create namespace retail-store
kubectl create secret generic rds-db-secrets \
  --from-literal=catalog-password='your-password' \
  --from-literal=orders-password='your-password' \
  -n retail-store

# 5. Deploy application
cd ../kubernetes
kubectl apply -f manifests/
kubectl patch svc ui -n retail-store -p '{"spec":{"type":"LoadBalancer"}}'

# Get your URL
kubectl get svc ui -n retail-store
```

**⏱️ Total deployment time:** ~20 minutes

---

## ✅ Project Achievements

### Core Requirements: 100% Complete
- ✅ Multi-tier microservices application deployed
- ✅ EKS cluster with high availability
- ✅ Service-to-service communication working
- ✅ Public internet access configured

### Bonus 1: Managed Persistence Layer (100% Complete)

**Enhanced from original StatefulSets to managed AWS services:**

- ✅ **Amazon RDS PostgreSQL** for orders service
  - Replaced in-cluster PostgreSQL StatefulSet
  - Automated backups and maintenance
  - Multi-AZ capable
  
- ✅ **Amazon RDS MySQL** for catalog service
  - Replaced in-cluster MySQL StatefulSet
  - Performance Insights enabled
  - Automated failover support
  
- ✅ **Amazon DynamoDB** for carts service
  - Replaced DynamoDB Local container
  - Serverless, auto-scaling
  - IAM Roles for Service Accounts (no hardcoded credentials!)
  
- ✅ **Kubernetes Secrets** for secure credential management
- ✅ **Removed all database StatefulSets** from cluster

### Bonus 2: Advanced Networking (100% Complete)
- ✅ AWS Load Balancer Controller installed and configured
- ✅ IAM policies and roles for ALB Controller
- ✅ Classic Load Balancer successfully provisioned
- ✅ Application publicly accessible via HTTP
- ✅ ACM certificate provisioned (ready for HTTPS)

**Note:** ALB via Ingress was configured but couldn't be provisioned due to AWS account service restrictions (common in educational accounts). Classic Load Balancer successfully provides the same public internet access.

---

## 🔒 Security Enhancements

**Improvements over original deployment:**

1. **IAM Roles for Service Accounts (IRSA)**
   - Carts service uses IAM role to access DynamoDB
   - No AWS credentials stored in pods or secrets
   - Automatic credential rotation by AWS

2. **Kubernetes Secrets**
   - RDS credentials encrypted at rest
   - Not hardcoded in manifests

3. **Network Security**
   - Worker nodes in private subnets
   - Security groups with least privilege
   - RDS instances in private subnets only

4. **Managed Services**
   - Automated patching and updates
   - Built-in backup and recovery
   - AWS-managed encryption

---

## 📊 Infrastructure Details

### Terraform Outputs

```bash
cd terraform && terraform output
```

Key outputs:
```
cluster_name              = "innovatemart-eks-cluster"
orders_pg_endpoint        = "innovatemart-orders-pg.coh82w20k2zy.us-east-1.rds.amazonaws.com:5432"
catalog_mysql_endpoint    = "innovatemart-catalog-mysql.coh82w20k2zy.us-east-1.rds.amazonaws.com:3306"
dynamodb_table_name       = "innovatemart-carts"
carts_role_arn            = "arn:aws:iam::378388077304:role/innovatemart-eks-cluster-carts-dynamodb-role"
alb_controller_role_arn   = "arn:aws:iam::378388077304:role/innovatemart-eks-cluster-alb-controller-role"
```

---

## 🧪 Verification Commands

```bash
# Check all pods
kubectl get pods -n retail-store

# Check services
kubectl get svc -n retail-store

# Verify database connections in logs
kubectl logs -n retail-store -l app=catalog --tail=20  # MySQL RDS
kubectl logs -n retail-store -l app=orders --tail=20   # PostgreSQL RDS
kubectl logs -n retail-store -l app=carts --tail=20    # DynamoDB

# Check RDS databases
aws rds describe-db-instances \
  --query 'DBInstances[?contains(DBInstanceIdentifier, `innovatemart`)].{Name:DBInstanceIdentifier,Status:DBInstanceStatus,Engine:Engine}'

# Check DynamoDB table
aws dynamodb describe-table --table-name innovatemart-carts

# Test application
curl -I http://$(kubectl get svc ui -n retail-store -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
```

---

## 🧹 Cleanup

**⚠️ Warning:** This will delete all resources including databases!

```bash
# Delete Kubernetes resources
kubectl delete namespace retail-store

# Delete Load Balancer Controller
helm uninstall aws-load-balancer-controller -n kube-system

# Destroy Terraform infrastructure
cd terraform
terraform destroy -auto-approve
```

---

## 📁 Repository Structure

```
innovatemart-eks-deployment/
├── README.md                          # This file
├── .gitignore                         # Git ignore rules
├── .github/
│   └── workflows/
│       └── terraform.yml              # CI/CD pipeline
├── terraform/
│   ├── main.tf                        # Main configuration
│   ├── vpc.tf                         # VPC and networking
│   ├── eks.tf                         # EKS cluster
│   ├── variables.tf                   # Input variables
│   ├── outputs.tf                     # Output values
│   ├── eks/
│   │   └── main.tf                    # EKS module
│   ├── rds/
│   │   ├── main.tf                    # RDS + DynamoDB
│   │   └── variables.tf               # RDS variables
│   ├── iam-dynamodb.tf                # IAM for carts → DynamoDB
│   └── iam-alb-controller.tf          # IAM for ALB controller
└── kubernetes/
    ├── deploy.sh                      # Deployment script
    └── manifests/
        ├── namespace.yaml
        ├── ui.yaml
        ├── catalog.yaml               # RDS MySQL
        ├── orders.yaml                # RDS PostgreSQL
        ├── carts.yaml                 # DynamoDB + IRSA
        ├── checkout.yaml
        ├── assets.yaml
        ├── rabbitmq.yaml
        └── ingress.yaml               # ALB Ingress
```

---

## 🛠️ Technologies Used

- **[AWS Retail Store Sample App](https://github.com/aws-containers/retail-store-sample-app)** - Base application
- **Amazon EKS** - Managed Kubernetes
- **Terraform** - Infrastructure as Code
- **Amazon RDS** - Managed PostgreSQL and MySQL
- **Amazon DynamoDB** - NoSQL database service
- **AWS Load Balancer Controller** - Kubernetes load balancing
- **Helm** - Kubernetes package manager
- **IAM Roles for Service Accounts (IRSA)** - Secure AWS access

---

## 📚 References

- [AWS Retail Store Sample App](https://github.com/aws-containers/retail-store-sample-app)
- [Amazon EKS Best Practices](https://aws.github.io/aws-eks-best-practices/)
- [AWS Load Balancer Controller](https://kubernetes-sigs.github.io/aws-load-balancer-controller/)
- [IAM Roles for Service Accounts](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html)

---

## 👤 Author

**Turner2**

**Date:** October 24, 2025

**Course:** Cloud Infrastructure / DevOps Engineering

---

## 🎓 Project Summary

This project demonstrates:
- ✅ **Kubernetes proficiency** - Multi-service orchestration
- ✅ **AWS expertise** - EKS, RDS, DynamoDB, IAM, VPC
- ✅ **Infrastructure as Code** - Terraform best practices
- ✅ **Security best practices** - IRSA, least privilege, secrets management
- ✅ **Production architecture** - Managed services, high availability
- ✅ **Problem-solving** - Account limitations overcome with alternatives

**All requirements completed:** Core + Bonus 1 + Bonus 2 ✅

---

## 📝 License

Based on the [AWS Retail Store Sample App](https://github.com/aws-containers/retail-store-sample-app).

Educational project enhancing the original with managed AWS services and production-grade infrastructure.
