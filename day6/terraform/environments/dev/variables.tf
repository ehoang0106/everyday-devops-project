# VPC Configuration
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.101.0/24"]
}

# EC2 Configuration
variable "ami_id" {
  description = "ID of AMI to use for the instance"
  type        = string
  default     = "ami-0e6a50b0059fd2cc3"
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.small"
}

variable "root_volume_size" {
  description = "Size of the root volume in gigabytes"
  type        = number
  default     = 20
}

variable "root_volume_encrypted" {
  description = "Whether to encrypt the root block device"
  type        = bool
  default     = true
}