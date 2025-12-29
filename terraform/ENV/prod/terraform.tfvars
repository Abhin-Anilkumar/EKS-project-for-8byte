aws_region     = "us-west-1"
cluster_name   = "prod-eks"
cluster_version = "1.29"

vpc_cidr = "10.0.0.0/16"

azs = ["us-west-1a", "us-west-1b"]

public_subnets = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnets = [
  "10.0.11.0/24",
  "10.0.12.0/24"
]
