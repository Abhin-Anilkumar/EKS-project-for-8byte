output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "rds_endpoint" {
  value = module.rds.endpoint
}

output "db_password" {
  value     = module.rds.password
  sensitive = true
}

output "ecr_repository_urls" {
  value = module.ecr.repository_urls
}
