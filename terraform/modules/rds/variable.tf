variable "vpc_id" {}
variable "db_subnets" {}
variable "eks_node_sg_id" {}

variable "db_name" {
  default = "appdb"
}

variable "db_username" {
  default = "appuser"
}

