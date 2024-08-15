variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "instance_type" {
  description = "instance type"
  type        = string
}

variable "node_count" {
  description = "desierd number of nodes in the EKS node group"
  type        = string
}

variable "min_node_count" {
  description = "Minimum number of nodes in the EKS node group"
  type        = string
}

variable "max_node_count" {
  description = "Maximum number of nodes in the EKS node group"
  type        = string
}

variable "region" {
  description = "AWS region where the EKS cluster will be created"
  type        = string
}

variable "kubernetes_version" {
  type    = string
  default = "1.21"  
}




