## Create a three tier web application in AWS

Using terraform to spin up a three tier web application in AWS.
The application consists of the following components:
- VPC with public and private subnets
- Internet Gateway
- NAT Gateway
- Security Groups
- Application Load Balancer
- Auto Scaling Group for web servers
- RDS Database instance
- S3 Bucket for static content
- EC2 Instances for web servers
- Route53 for DNS management