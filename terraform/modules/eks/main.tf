module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  cluster_endpoint_private_access = var.cluster_endpoint_private_access

  cluster_enabled_log_types = [
    "api", "audit", "authenticator", "controllerManager", "scheduler"
  ]

  cloudwatch_log_group_retention_in_days = 90
  cluster_service_ipv4_cidr              = var.cluster_service_ipv4_cidr

  enable_irsa = true

  eks_managed_node_groups = {
    default = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.medium"]
      subnet_ids     = var.private_subnets

      iam_role_additional_policies = {
        EKSWorker = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
        ECRRead   = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        CNI       = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
      }
    }
  }
}
