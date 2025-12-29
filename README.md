# EKS Infrastructure with Terraform

This project provisions an Amazon EKS cluster and related infrastructure on AWS using Terraform.

## Architecture Overview

The configuration deploys the following resources:
- **Network**: VPC with Public and Private subnets across multiple Availability Zones.
- **Compute**: EKS Cluster (v1.34) with Managed Node Groups (t3.medium).
- **Database**: Amazon RDS PostgreSQL instance (db.t3.medium, Multi-AZ).
- **Security**: IAM Roles (IRSA), Security Groups, and KMS encryption for cluster secrets.
- **Add-ons**: AWS Load Balancer Controller, CoreDNS, VPC CNI, EBS CSI Driver.

## Prerequisites

- Terraform >= 1.4.0
- AWS CLI configured with appropriate credentials

## Project Structure

```
terraform/
├── ENV/
│   └── prod/          # Production environment implementation
├── modules/
│   ├── eks/           # EKS Cluster module wrapper
│   ├── nodegroup/     # EKS Node Group module wrapper
│   ├── rds/           # RDS Database module
│   ├── vpc/           # VPC Networking module
│   └── alb-controller/# AWS Load Balancer Controller module
```

## Usage

1. **Initialize Terraform**:
   Navigate to the environment directory and initialize the project.
   ```bash
   cd terraform/ENV/prod
   terraform init
   ```

2. **Review Plan**:
   Generate a plan to preview changes.
   ```bash
   terraform plan
   ```

3. **Deploy**:
   Apply the configuration to provision resources.
   ```bash
   terraform apply
   ```

## Configuration

Key variables are defined in `terraform.tfvars`:
- `aws_region`: AWS Region (e.g., `us-west-1`)
- `cluster_version`: Kubernetes version (e.g., `1.34`)
- `azs`: Availability Zones (Must be valid for the region, e.g., `us-west-1b`, `us-west-1c`)
- `vpc_cidr`: CIDR block for the VPC

## Notes

- **Module Versions**: The EKS and NodeGroup modules are pinned to `~> 19.0` to maintain compatibility with the existing code structure.
- **Providers**: The AWS Provider is pinned to `~> 5.0` and Kubernetes Provider to `~> 2.23` to avoid deprecation warnings and compatibility issues.
