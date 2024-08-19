locals {
  env         = "prod"
  region      = "var.region
  zone1       = "us-east-1a"
  zone2       = "us-east-1b"
  eks_name    = var.cluster_name
  eks_version = "1.30"
}