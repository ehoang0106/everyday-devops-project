variable "cidr_block" {
  type = string
  description = "IP Address for VPC"
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
  default     = "my_vpc"
}