# Local values
locals {
  project_name = "weather-app"
  environment  = "dev"

  common_tags = {
    Project     = local.project_name
    Environment = local.environment
    Terraform   = "true"
  }
}

# VPC Module
module "vpc" {
  source = "../../modules/vpc"

  vpc_name       = "${local.project_name}-vpc"
  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets

  tags = local.common_tags
}

# Security Group Module
module "security_group" {
  source = "../../modules/security-group"

  name_prefix         = "${local.project_name}-sg"
  security_group_name = "${local.project_name}-security-group"
  vpc_id             = module.vpc.vpc_id

  ingress_rules = [
    {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "HTTP Alt"
      from_port   = 81
      to_port     = 81
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress_rules = [
    {
      description = "All outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = local.common_tags
}

# EC2 Instance Module
module "ec2" {
  source = "../../modules/ec2"

  ami_id                      = var.ami_id
  instance_type              = var.instance_type
  instance_name              = "${local.project_name}-instance"
  subnet_id                  = module.vpc.public_subnets[0]
  security_group_ids         = [module.security_group.security_group_id]
  associate_public_ip_address = true
  user_data                  = file("${path.module}/user_data.sh")

  root_volume_size      = var.root_volume_size
  root_volume_encrypted = var.root_volume_encrypted

  tags = local.common_tags
}