# Get available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# VPC Module
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs            = [data.aws_availability_zones.available.names[0]]
  public_subnets = var.public_subnets

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = var.tags
}