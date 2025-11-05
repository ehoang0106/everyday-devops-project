# Security Group Module

This module creates an AWS security group with configurable ingress and egress rules.

## Usage

```hcl
module "security_group" {
  source = "./modules/security-group"

  name_prefix           = "web-sg"
  security_group_name   = "web-security-group"
  vpc_id               = module.vpc.vpc_id

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
    }
  ]

  egress_rules = [
    {
      description = "All outbound"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Environment = "dev"
    Project     = "weather-app"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name_prefix | Name prefix for the security group | `string` | n/a | yes |
| security_group_name | Name tag for the security group | `string` | n/a | yes |
| vpc_id | ID of the VPC where to create security group | `string` | n/a | yes |
| ingress_rules | List of ingress rules | `list(object)` | `[]` | no |
| egress_rules | List of egress rules | `list(object)` | `[]` | no |
| tags | A map of tags to assign to the resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| security_group_id | ID of the security group |
| security_group_name | Name of the security group |
| security_group_arn | ARN of the security group |