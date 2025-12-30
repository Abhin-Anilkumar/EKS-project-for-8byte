module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr = var.vpc_cidr
  azs      = var.azs

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  cluster_name    = var.cluster_name
}

module "eks" {
  source                          = "../../modules/eks"
  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  vpc_id                          = module.vpc.vpc_id
  private_subnets                 = module.vpc.private_subnets
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
}

# module "nodegroup" {
#   source          = "../../modules/nodegroup"
#   cluster_name    = module.eks.cluster_name
#   cluster_version = var.cluster_version
#   private_subnets = module.vpc.private_subnets
# }



module "rds" {
  source = "../../modules/rds"

  vpc_id         = module.vpc.vpc_id
  db_subnets     = module.vpc.private_subnets
  eks_node_sg_id = module.eks.node_security_group_id
}

module "alb_controller" {
  source = "../../modules/alb-controller"

  oidc_provider     = module.eks.oidc_provider
  oidc_provider_arn = module.eks.oidc_provider_arn
}


module "ecr" {
  source = "../../modules/ecr"

  repository_names = ["frontend", "catalogue", "voting", "recommendation"]
}
