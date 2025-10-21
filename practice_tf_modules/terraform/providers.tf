terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.17.0"
    }
  }

  backend "s3" {
    bucket = "terraform-state-khoa-hoang"
    key = "terraform_state_pracitce_tf_modules"
    region = "us-west-1"
    
  }
}

provider "aws" {
  region = "us-west-1"
}