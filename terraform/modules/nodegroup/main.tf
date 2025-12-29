module "node_group" {
  source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "20.8.4"

  name             = "app-nodes"
  cluster_name     = var.cluster_name
  cluster_version  = var.cluster_version
  subnet_ids       = var.private_subnets

  instance_types = ["t3.medium"]

  min_size     = 2
  desired_size = 2
  max_size     = 5
}

