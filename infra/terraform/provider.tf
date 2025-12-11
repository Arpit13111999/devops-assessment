terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.28.0"
    }
  }

  backend "s3" {
    bucket         = "arpit-s3" 
    key            = "devops-assessment/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"             # for locking
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}
