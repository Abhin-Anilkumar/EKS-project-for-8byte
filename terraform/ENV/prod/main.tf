module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr = "10.0.0.0/16"
  azs = ["ap-south-1a", "ap-south-1b"]

  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]
}

module "eks" {
  source = "../../modules/eks"

  cluster_name    = "prod-eks"
  cluster_version = "1.29"

  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
}

module "nodegroup" {
  source = "../../modules/nodegroup"

  cluster_name     = module.eks.cluster_name
  cluster_version  = "1.29"
  private_subnets  = module.vpc.private_subnets
}



module "rds" {
  source = "../../modules/rds"

  vpc_id          = module.vpc.vpc_id
  db_subnets      = module.vpc.private_subnets
  eks_node_sg_id  = module.eks.node_security_group_id
}

module "alb_controller" {
  source = "../../modules/alb-controller"

  oidc_provider     = module.eks.oidc_provider
  oidc_provider_arn = module.eks.oidc_provider_arn
}

