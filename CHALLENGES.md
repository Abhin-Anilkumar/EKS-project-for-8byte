# Challenges & Resolutions

During the deployment of the Craftista application on EKS, several critical challenges were encountered. This document outlines those issues and how they were resolved.

## 1. Cross-Architecture Image Mismatches
**Challenge**: Builds performed on modern macOS (Apple Silicon) default to `linux/arm64`. When deployed to EKS worker nodes (which use `linux/amd64`), pods would fail with `exec format error`, or remain in `ImagePullBackOff` if the image wasn't even found in the expected registry.
**Resolution**: All Docker builds were updated to use the `--platform linux/amd64` flag. This ensured total compatibility with the AWS AL2 worker nodes.

## 2. AWS Account Load Balancer Restrictions
**Challenge**: The AWS Load Balancer Controller would consistently fail to provision an ALB, reporting that the account was restricted from creating load balancers.
**Resolution**: This was identified as an account-level limitation (quota or restriction) rather than a technical misconfiguration. The infrastructure was pre-emptively fixed (subnets tagged, IRSA configured) to ensure immediate provisioning as soon as the restriction is lifted by AWS Support.

## 3. Internal Service Discovery Failures (ENOTFOUND)
**Challenge**: The `frontend` pod was unable to reach the `catalogue` service, resulting in `getaddrinfo ENOTFOUND catalogue`. While Kubernetes DNS (CoreDNS) was healthy, short-name resolution was inconsistent.
**Resolution**: Standardized internal service URIs to use Fully Qualified Domain Names (FQDNs), such as `http://catalogue.app.svc.cluster.local:5000`. This resolved all DNS resolution ambiguity and ensured stable inter-service communication.

## 4. Network Isolation & Split Node Groups
**Challenge**: Pods were sporadically unable to communicate even with correct DNS. Investigation revealed that the `frontend` and `catalogue` pods were landing on different node groups (`default` vs `app-nodes`) with isolated Security Groups.
**Resolution**: Consolidated all workloads onto a single EKS-managed node group. This ensured all pods shared the same security context and VPC CNI network configuration, eliminating connectivity hangs.

## 5. Persistence Migration
**Challenge**: The `voting` service was losing all data (votes) during restarts because it used an in-memory H2 database.
**Resolution**: Integrated the service with RDS PostgreSQL. This involved:
- Adding the PostgreSQL JDBC driver to the Maven `pom.xml`.
- Standardizing the application to take database configuration via environment variables.
- Securing credentials using Kubernetes Secrets.
- Updating the Security Group to allow ingress on 5432 from the node group.
