variable "cluster_name" {}
variable "cluster_version" {}
variable "vpc_id" {}
variable "private_subnets" {}

variable "cluster_endpoint_public_access" {
  type    = bool
  default = true
}

variable "cluster_endpoint_private_access" {
  type    = bool
  default = false
}

variable "cluster_service_ipv4_cidr" {
  type    = string
  default = null
}
