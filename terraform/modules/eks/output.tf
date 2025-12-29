output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_ca_certificate" {
  description = "EKS cluster certificate authority"
  value       = module.eks.cluster_certificate_authority_data
}

output "node_security_group_id" {
  description = "Security group ID for the EKS nodes"
  value       = module.eks.node_security_group_id
}

output "oidc_provider" {
  description = "The OIDC provider URL"
  value       = module.eks.oidc_provider
}

output "oidc_provider_arn" {
  description = "The OIDC provider ARN"
  value       = module.eks.oidc_provider_arn
}
