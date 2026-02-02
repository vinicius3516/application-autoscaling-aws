# Provision VPC
module "vpc" {
  source = "./modules/vpc"

  environment = var.environment
  vpc_az      = var.vpc_az
  aws_region  = "us-east-1"

  subnet_az1 = "us-east-1a"
  subnet_az2 = "us-east-1b"
  subnet_az3 = "us-east-1c"

  vpc_cidr_block = "10.0.0.0/16"

  # Public subnets
  public_subnet_az1_cidr = "10.0.0.0/24"
  public_subnet_az2_cidr = "10.0.1.0/24"
  public_subnet_az3_cidr = "10.0.2.0/24"


  # Private subnets
  private_subnet_az1_cidr = "10.0.10.0/24"
  private_subnet_az2_cidr = "10.0.11.0/24"
  private_subnet_az3_cidr = "10.0.12.0/24"


  # Database subnets
  database_subnet_az1_cidr = "10.0.20.0/24"
  database_subnet_az2_cidr = "10.0.21.0/24"
  database_subnet_az3_cidr = "10.0.22.0/24"
}