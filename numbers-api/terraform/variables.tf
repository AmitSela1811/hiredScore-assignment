variable "aws_region" {
  description = "The AWS region where resources will be created"
  type        = string
}

variable "aws_account_id" {
  description = "The AWS Account ID"
  type        = string
}

variable "github_repository" {
  description = "The GitHub repository in the format 'owner/repo'"
  type        = string
}

variable "branch" {
  description = "The branch name in your GitHub repository"
  type        = string
}

variable "service_name" {
  description = "The name of the service (ECR repository name)"
  type        = string
}
