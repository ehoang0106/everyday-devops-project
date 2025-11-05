# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Structure

This is a Day 6 DevOps project that demonstrates deploying a weather application on AWS infrastructure using Terraform and Docker/nginx.

The repository contains:
- `weather-app/`: A vanilla JavaScript weather application with nginx Docker deployment
- `terraform/`: AWS infrastructure as code using Terraform modules

## Preferences

- You are an expert who double-checks things
- You are skeptical and you do research when unsure
- I am not always right, neither are you, but we both strive for accuracy
- When providing code snippets, ensure they are complete and functional
- When explaining concepts, use clear and concise language
- When suggesting improvements, consider best practices and maintainability


## Weather Application

The weather app is a modern, minimalist weather application with the following stack:
- Frontend: HTML5, CSS3, Vanilla JavaScript (ES6+)
- APIs: OpenWeatherMap API, IPregistry API for geolocation
- Deployment: nginx in Docker container

### Development Commands

#### Docker Development
```bash
# Build the Docker image
docker build -t weather-app ./weather-app

# Run the container
docker run -d -p 8080:80 --name weather-app weather-app

# View logs
docker logs weather-app

# Stop and remove
docker stop weather-app
docker rm weather-app
```

#### Local Development
```bash
# Run without Docker (from weather-app directory)
python3 -m http.server 8000
# Then access http://localhost:8000
```

### Configuration
The weather app requires an OpenWeatherMap API key to be configured in `weather-app/app.js`:
```javascript
const API_KEY = 'YOUR_API_KEY_HERE';
```

## Terraform Infrastructure

### Commands
```bash
# Initialize Terraform (from terraform directory)
terraform init

# Plan infrastructure changes
terraform plan

# Apply infrastructure
terraform apply

# Destroy infrastructure
terraform destroy
```

### Architecture
- Uses AWS provider with us-west-1 region
- Remote state stored in S3 bucket: "terraform-state-khoa-hoang"
- Creates VPC using terraform-aws-modules/vpc/aws module
- VPC spans 3 AZs (eu-west-1a, eu-west-1b, eu-west-1c) with both public and private subnets
- CIDR: 10.0.0.0/16 with /24 subnets

## Important Notes

- The Terraform state backend is configured for S3 remote state
- The project targets EU West 1 for VPC resources but uses US West 1 as provider region
- Weather app Docker image uses nginx:alpine base for lightweight deployment
- No package.json or npm scripts - this is a vanilla JavaScript project