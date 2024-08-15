provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "hired-score-tf"
    key            = "terraform/numbers-api/state.tfstate"
    region         = "us-east-1"
  }
}

resource "aws_ecr_repository" "numbers_api_ecr_repo" {
  name                 = "numbers-api" 
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "forwarder_ecr_repo" {
  name                 = "forwarder" 
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
