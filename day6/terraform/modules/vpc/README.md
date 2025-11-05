# VPC Module

This module creates a VPC with public subnets, internet gateway, and route tables using the terraform-aws-modules/vpc/aws module.

## Usage

```hcl
module "vpc" {
  source = "./modules/vpc"

  vpc_name       = "my-vpc"
  vpc_cidr       = "10.0.0.0/16"
  public_subnets = ["10.0.101.0/24"]

  tags = {
    Environment = "dev"
    Project     = "weather-app"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_name | Name of the VPC | `string` | n/a | yes |
| vpc_cidr | CIDR block for VPC | `string` | n/a | yes |
| public_subnets | List of public subnet CIDR blocks | `list(string)` | n/a | yes |
| tags | A map of tags to assign to the resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | ID of the VPC |
| public_subnets | List of IDs of public subnets |
| public_subnet_cidrs | List of CIDR blocks of public subnets |
| internet_gateway_id | The ID of the Internet Gateway |
| public_route_table_ids | List of IDs of the public route tables |