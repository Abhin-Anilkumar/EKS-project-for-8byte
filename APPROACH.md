# Project Approach

This document outlines the architectural decisions and technical rationale for the Craftista EKS deployment.

## Architectural Overview

The goal was to deploy a highly available, scalable, and secure microservices application on AWS EKS. The architecture leverages managed services wherever possible to minimize operational overhead.

### 1. Network Infrastructure (VPC)
- **Multi-AZ Deployment**: Subnets are distributed across multiple Availability Zones (`us-east-1a`, `us-east-1b`) to ensure high availability.
- **Segmentation**: Public subnets host the Application Load Balancer (ALB), while private subnets host the EKS worker nodes and RDS instances to ensure zero direct public access to backend components.
- **ALB Discovery**: Subnets are tagged with `kubernetes.io/role/elb` and `kubernetes.io/role/internal-elb` to allow the AWS Load Balancer Controller to automatically discover and provision ALBs.

### 2. EKS Cluster Design
- **Unified Node Group**: Initially, workloads were split across node groups. We transitioned to a unified `default` node group to simplify Security Group management and resolve inter-pod connectivity issues caused by network isolation between groups.
- **Architecture Compatibility**: Node groups are configured to use `linux/amd64` (AL2) to match the application's compiled dependencies.

### 3. Service Discovery & Connectivity
- **Internal FQDNs**: Microservices communicate using Fully Qualified Domain Names (e.g., `catalogue.app.svc.cluster.local`) rather than short names. This ensures reliable DNS resolution across different namespaces and improves cluster-wide discovery stability.
- **Consistent Protocols**: Standardized all internal endpoints to use consistent port mappings (e.g., frontend on 3000, catalogue on 5000, etc.).

### 4. Security & IAM
- **IRSA (IAM Roles for Service Accounts)**: Instead of providing broad permissions to the entire node group, we use IRSA for the AWS Load Balancer Controller. This follows the principle of least privilege by allowing the controller's specific Kubernetes service account to assume a unique IAM role.
- **Security Groups**: A centralized security group strategy was implemented where the RDS instance only accepts traffic from the EKS node group security group on port 5432.

### 5. Persistence
- **RDS PostgreSQL**: The `voting` service was migrated from an in-memory H2 database to a managed RDS PostgreSQL instance. This ensures data persistence across pod restarts and provides enterprise-grade backup and scaling capabilities.

### 6. Deployment Strategy
- **Helm**: Componentized deployment using Helm charts for each microservice, allowing for environment-specific value overrides and structured rollouts.
- **Rolling Restarts**: Used `kubectl rollout restart` to ensure zero-downtime updates when applying new configurations or image changes.
