# EC2 Module

This module creates an AWS EC2 instance with configurable parameters.

## Usage

```hcl
module "ec2" {
  source = "./modules/ec2"

  ami_id                      = "ami-0e6a50b0059fd2cc3"
  instance_type              = "t3.small"
  instance_name              = "web-server"
  subnet_id                  = module.vpc.public_subnets[0]
  security_group_ids         = [module.security_group.security_group_id]
  associate_public_ip_address = true
  user_data                  = file("${path.module}/user_data.sh")

  root_volume_type      = "gp3"
  root_volume_size      = 20
  root_volume_encrypted = true

  tags = {
    Environment = "dev"
    Project     = "weather-app"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ami_id | ID of AMI to use for the instance | `string` | n/a | yes |
| instance_type | The type of instance to start | `string` | n/a | yes |
| instance_name | Name tag for the instance | `string` | n/a | yes |
| subnet_id | The VPC Subnet ID to launch in | `string` | n/a | yes |
| security_group_ids | A list of security group IDs to associate with | `list(string)` | n/a | yes |
| associate_public_ip_address | Whether to associate a public IP address with an instance in a VPC | `bool` | `false` | no |
| user_data | The user data to provide when launching the instance | `string` | `null` | no |
| root_volume_type | Type of volume for root block device | `string` | `"gp3"` | no |
| root_volume_size | Size of the root volume in gigabytes | `number` | `8` | no |
| root_volume_encrypted | Whether to encrypt the root block device | `bool` | `true` | no |
| tags | A map of tags to assign to the resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance_id | ID of the EC2 instance |
| instance_arn | ARN of the EC2 instance |
| public_ip | Public IP address assigned to the instance |
| private_ip | Private IP address assigned to the instance |
| public_dns | Public DNS name assigned to the instance |
| private_dns | Private DNS name assigned to the instance |