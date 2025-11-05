# Weather App Infrastructure

This Terraform configuration deploys a weather application on AWS using a modular approach.

## Architecture

- **VPC**: Single availability zone with public subnet
- **Security Group**: Allows ingress on ports 22, 80, 81, 443
- **EC2 Instance**: Ubuntu 22.04 with Docker and weather app

## Structure

```
terraform/
├── modules/                  # Reusable modules
│   ├── vpc/                  # VPC module
│   ├── ec2/                  # EC2 module
│   └── security-group/       # Security Group module
├── environments/             # Environment-specific configurations
│   ├── dev/                  # Development environment
│   │   ├── main.tf           # Dev-specific resource composition
│   │   ├── variables.tf      # Dev input variables
│   │   ├── outputs.tf        # Dev outputs
│   │   ├── provider.tf       # AWS provider config
│   │   ├── user_data.sh      # EC2 initialization script
│   │   └── terraform.tfvars  # Dev-specific values
│   ├── staging/              # Staging environment
│   └── prod/                 # Production environment
├── provider.tf               # Shared provider configuration
├── user_data.sh              # EC2 initialization script
├── terraform.tfvars.example  # Example variables file
└── README.md                 # This file
```

## Usage

### Development Environment

```bash
# Navigate to dev environment
cd environments/dev

# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Apply the configuration
terraform apply

# Access the weather app at the output URL
```

### Adding New Environments

1. **Create environment directory**:
   ```bash
   mkdir -p environments/staging
   cp -r environments/dev/* environments/staging/
   ```

2. **Modify environment-specific values**:
   ```bash
   # Edit environments/staging/terraform.tfvars
   # Change instance_type, vpc_cidr, etc. for staging
   ```

3. **Deploy staging**:
   ```bash
   cd environments/staging
   terraform init
   terraform apply
   ```

## Why This Structure?

### ✅ **Environment Separation**
- **Dev/Staging/Prod** have separate state files
- **Independent deployments** - changes to dev don't affect prod
- **Environment-specific configurations** (instance sizes, etc.)

### ✅ **Module Reusability**
- **Same modules** used across all environments
- **Consistent infrastructure** patterns
- **Easy to maintain** and update

### ✅ **Real-World Best Practices**
- **Follows enterprise patterns** used by major organizations
- **Scalable** for teams and complex infrastructure
- **Clear separation** of concerns

## Module Documentation

Each module has its own README with usage examples:
- [VPC Module](./modules/vpc/README.md)
- [EC2 Module](./modules/ec2/README.md)
- [Security Group Module](./modules/security-group/README.md)

## Cleanup

```bash
# From any environment directory
terraform destroy
```