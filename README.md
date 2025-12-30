# AWS EKS Infrastructure with Terraform

This repository contains the Terraform configuration to provision a production-grade AWS EKS cluster, including networking, database, and container orchestration components.

## Project Structure

The project follows a modular structure to ensure reusability and maintainability:

```text
terraform/
├── ENV/
│   └── prod/               # Production environment deployment
│       ├── main.tf         # Main orchestration of modules
│       ├── variables.tf    # Input variables
│       ├── terraform.tfvars # Environment-specific values
│       ├── backend.tf      # Remote state configuration (S3/DynamoDB)
│       ├── providers.tf    # AWS, Helm, and Kubernetes providers
│       ├── helm.tf         # Helm releases (ALB Controller, etc.)
│       └── outputs.tf      # Exported cluster and DB details
└── modules/                # Reusable Infrastructure Modules
    ├── vpc/                # Network: VPC, Subnets, IGW, NAT
    ├── eks/                # Compute: EKS Cluster & Managed Node Groups
    ├── rds/                # Database: PostgreSQL Instance
    ├── alb-controller/     # Ingress: IAM roles for Load Balancer Controller
    └── ecr/                # Registry: Container Repositories
```

## Core Components

- **VPC**: A dedicated VPC with public and private subnets across multiple AZs, tagged for ALB auto-discovery.
- **EKS**: A managed Kubernetes cluster with a unified node group for consistent security and networking.
- **RDS**: A private PostgreSQL instance for persistent data storage, accessible only from the EKS nodes.
- **ALB Controller**: Configured with IRSA (IAM Roles for Service Accounts) to manage Application Load Balancers via Kubernetes Ingress.
- **ECR**: Private repositories for frontend and backend microservices.

## Prerequisites

- **AWS CLI** configured with appropriate permissions.
- **Terraform** (v1.0+) installed locally.
- **kubectl** for cluster management.

## Deployment Steps

1. **Initialize Terraform**:
   ```bash
   cd terraform/ENV/prod
   terraform init
   ```

2. **Preview Changes**:
   ```bash
   terraform plan
   ```

3. **Apply Configuration**:
   ```bash
   terraform apply
   ```

4. **Update kubeconfig**:
   ```bash
   aws eks update-kubeconfig --region us-east-1 --name prod-eks
   ```

## Remote State

The infrastructure state is stored remotely in an S3 bucket with state locking via DynamoDB to prevent concurrent modifications. Configuration can be found in `ENV/prod/backend.tf`.
