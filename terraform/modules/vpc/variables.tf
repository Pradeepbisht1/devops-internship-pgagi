variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_a_cidr" {
  description = "CIDR block for public subnet A"
  type        = string
}

variable "public_subnet_b_cidr" {
  description = "CIDR block for public subnet B"
  type        = string
}

variable "az_a" {
  description = "Availability zone A"
  type        = string
}

variable "az_b" {
  description = "Availability zone B"
  type        = string
}
