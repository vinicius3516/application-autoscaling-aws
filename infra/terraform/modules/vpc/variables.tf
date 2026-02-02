variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "vpc_az" {
  description = "VPC identifier"
  type        = string
  default     = "main"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_az1" {
  description = "Availability Zone 1"
  type        = string
}

variable "subnet_az2" {
  description = "Availability Zone 2"
  type        = string
}

variable "subnet_az3" {
  description = "Availability Zone 3"
  type        = string
}

# Public Subnets
variable "public_subnet_az1_cidr" {
  description = "CIDR block for public subnet in AZ1"
  type        = string
  default     = "10.0.0.0/24"
}

variable "public_subnet_az2_cidr" {
  description = "CIDR block for public subnet in AZ2"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_az3_cidr" {
  description = "CIDR block for public subnet in AZ3"
  type        = string
  default     = "10.0.2.0/24"
}

# Private Subnets
variable "private_subnet_az1_cidr" {
  description = "CIDR block for private subnet in AZ1"
  type        = string
  default     = "10.0.10.0/24"
}

variable "private_subnet_az2_cidr" {
  description = "CIDR block for private subnet in AZ2"
  type        = string
  default     = "10.0.11.0/24"
}

variable "private_subnet_az3_cidr" {
  description = "CIDR block for private subnet in AZ3"
  type        = string
  default     = "10.0.12.0/24"
}

# Database Subnets
variable "database_subnet_az1_cidr" {
  description = "CIDR block for database subnet in AZ1"
  type        = string
  default     = "10.0.20.0/24"
}

variable "database_subnet_az2_cidr" {
  description = "CIDR block for database subnet in AZ2"
  type        = string
  default     = "10.0.21.0/24"
}

variable "database_subnet_az3_cidr" {
  description = "CIDR block for database subnet in AZ3"
  type        = string
  default     = "10.0.22.0/24"
}

# VPC Endpoints
variable "enable_s3_endpoint" {
  description = "Enable S3 VPC Endpoint"
  type        = bool
  default     = true
}