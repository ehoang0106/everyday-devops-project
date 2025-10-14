#ec2 ami

variable "ami" {
  description = "Amazon Linux 2023 AMI 2023.9.20250929.0 x86_64 HVM kernel-6.1"
  type        = string
  default     = "ami-0b967c22fe917319b"
}