resource "aws_iam_role" "var.cluster_name" {
  name = "eks-cluster-var.cluster_name"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "var.cluster_name-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.var.cluster_name.name
}

resource "aws_eks_cluster" "var.cluster_name" {
  name     = "var.cluster_name"
  role_arn = aws_iam_role.var.cluster_name.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.private-us-east-1a.id,
      aws_subnet.private-us-east-1b.id,
      aws_subnet.public-us-east-1a.id,
      aws_subnet.public-us-east-1b.id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.var.cluster_name-AmazonEKSClusterPolicy]
} 

terraform {
  backend "s3" {
    bucket         = "eks-creation-terraform"
    key            = "terraform/state.tfstate"
    region         = "us-east-1"
  }
}
