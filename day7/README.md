## Build infrastructure on AWS to deploy a containerized web app on ECS with Terraform

To refresh my knowledge of Terraform and AWS ECS, this project focuses on Amazon ECS deployment using EC2 with Terraform.

Containerize a simple weather web app (served by nginx)

Goals
- Containerize the app with Docker (nginx as needed) and push images to Amazon ECR.
- Provision networking (VPC, subnets, IGW, route tables), ALB, ECS cluster, task definition, and service via Terraform.
- Configure IAM roles, security groups, and autoscaling; expose the app through an ALB and output its DNS name.
- Use a remote Terraform backend S3 for state and locking.

High-level workflow
1. Create a Dockerfile and build/test the container locally (nginx + app).
2. Create an ECR repository and push the image.
3. Write Terraform modules/resources for: VPC, subnets, ALB, security groups, IAM, ECR, ECS cluster, task definition, service, autoscaling.
4. Validate via the ALB DNS (or Route53 record).

