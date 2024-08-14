provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "numbers-api-terraform"
    key            = "terraform/state.tfstate"
    region         = "us-east-1"
  }
}

resource "aws_ecr_repository" "my_ecr_repo" {
  name                 = "numbers-api" 
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
