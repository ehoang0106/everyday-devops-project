terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket = "terraform-state-khoa-hoang"
    key    = "terraform_state_7days_day2"
    regions = "us-west-1"

  }

}

provider "aws" {
  region = "us-west-1"
}