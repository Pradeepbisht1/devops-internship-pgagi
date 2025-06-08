variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "alert_email" {
  description = "Email address for receiving CloudWatch alerts"
  type        = string
}

variable "public_subnet_a_cidr" {
  description = "CIDR block for public subnet A"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_b_cidr" {
  description = "CIDR block for public subnet B"
  type        = string
  default     = "10.0.2.0/24"
}

variable "az_a" {
  description = "Availability zone A"
  type        = string
  default     = "ap-south-1a"
}

variable "az_b" {
  description = "Availability zone B"
  type        = string
  default     = "ap-south-1b"
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "ap-south-1"
}

variable "secret_value" {
  type      = string
  sensitive = true
}
