provider "aws" {
  region = var.aws_region
}

# Create IAM Role for GitHub Actions
resource "aws_iam_role" "github_actions_role" {
  name = "github-actions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${var.aws_account_id}:oidc-provider/token.actions.githubusercontent.com"
        }
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" : "repo:${var.github_repository}:ref:refs/heads/${var.branch}"
          }
        }
      }
    ]
  })
}

# Attach policies to the IAM Role
resource "aws_iam_role_policy_attachment" "ecr_access" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

# Create an ECR repository
resource "aws_ecr_repository" "this" {
  name = var.service_name
}

# Output the role ARN and ECR repository URL
output "github_actions_role_arn" {
  value = aws_iam_role.github_actions_role.arn
}

output "ecr_repository_url" {
  value = aws_ecr_repository.this.repository_url
}
