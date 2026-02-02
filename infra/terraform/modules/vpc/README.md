# AWS VPC Terraform Module

Terraform module for provisioning a complete VPC on AWS, following best practices for high availability and security architecture.

## Overview

This module creates a complete VPC network infrastructure with multi-AZ architecture (3 Availability Zones), including public, private, and database subnets, with appropriate routing for each layer.

## Architecture

![AWS VPC Diagram](Diagrama%20Aws%20VPC.png)

## Provisioned Resources

| Resource | Quantity | Description |
|----------|----------|-------------|
| VPC | 1 | Virtual Private Cloud with DNS enabled |
| Internet Gateway | 1 | Gateway for internet access |
| Elastic IP | 3 | Static IPs for NAT Gateways |
| NAT Gateway | 3 | One per AZ for high availability |
| Public Subnet | 3 | One per AZ, with automatic public IP |
| Private Subnet | 3 | One per AZ, for applications |
| Database Subnet | 3 | One per AZ, isolated from internet |
| Public Route Table | 1 | Route to Internet Gateway |
| Private Route Table | 3 | One per AZ, route to local NAT Gateway |
| Database Route Table | 1 | No internet route |

## File Structure

```
vpc/
├── main.tf           # Resource definitions
├── variables.tf      # Input variables
├── outputs.tf        # Output values
├── README.md         # This documentation
└── Diagrama Aws VPC.png  # Visual architecture diagram
```

## Input Variables

### Required

| Name | Type | Description |
|------|------|-------------|
| `environment` | string | Environment name (dev, staging, prod) |
| `subnet_az1` | string | Availability Zone 1 (e.g.: us-east-1a) |
| `subnet_az2` | string | Availability Zone 2 (e.g.: us-east-1b) |
| `subnet_az3` | string | Availability Zone 3 (e.g.: us-east-1c) |

### Optional (with default values)

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `vpc_az` | string | `"main"` | VPC identifier |
| `aws_region` | string | `"us-east-1"` | AWS Region |
| `vpc_cidr_block` | string | `"10.0.0.0/16"` | VPC CIDR block |
| `public_subnet_az1_cidr` | string | `"10.0.0.0/24"` | Public subnet AZ1 CIDR |
| `public_subnet_az2_cidr` | string | `"10.0.1.0/24"` | Public subnet AZ2 CIDR |
| `public_subnet_az3_cidr` | string | `"10.0.2.0/24"` | Public subnet AZ3 CIDR |
| `private_subnet_az1_cidr` | string | `"10.0.10.0/24"` | Private subnet AZ1 CIDR |
| `private_subnet_az2_cidr` | string | `"10.0.11.0/24"` | Private subnet AZ2 CIDR |
| `private_subnet_az3_cidr` | string | `"10.0.12.0/24"` | Private subnet AZ3 CIDR |
| `database_subnet_az1_cidr` | string | `"10.0.20.0/24"` | Database subnet AZ1 CIDR |
| `database_subnet_az2_cidr` | string | `"10.0.21.0/24"` | Database subnet AZ2 CIDR |
| `database_subnet_az3_cidr` | string | `"10.0.22.0/24"` | Database subnet AZ3 CIDR |

## Outputs

| Name | Description |
|------|-------------|
| `vpc_id` | VPC ID |
| `vpc_cidr_block` | VPC CIDR block |
| `public_subnet_az1_id` | Public subnet AZ1 ID |
| `public_subnet_az2_id` | Public subnet AZ2 ID |
| `public_subnet_az3_id` | Public subnet AZ3 ID |
| `public_subnet_ids` | List of public subnet IDs |
| `private_subnet_az1_id` | Private subnet AZ1 ID |
| `private_subnet_az2_id` | Private subnet AZ2 ID |
| `private_subnet_az3_id` | Private subnet AZ3 ID |
| `private_subnet_ids` | List of private subnet IDs |
| `database_subnet_az1_id` | Database subnet AZ1 ID |
| `database_subnet_az2_id` | Database subnet AZ2 ID |
| `database_subnet_az3_id` | Database subnet AZ3 ID |
| `database_subnet_ids` | List of database subnet IDs |
| `internet_gateway_id` | Internet Gateway ID |
| `nat_gateway_az1_id` | NAT Gateway AZ1 ID |
| `nat_gateway_az2_id` | NAT Gateway AZ2 ID |
| `nat_gateway_az3_id` | NAT Gateway AZ3 ID |
| `public_route_table_id` | Public Route Table ID |
| `private_route_table_az1_id` | Private Route Table AZ1 ID |
| `private_route_table_az2_id` | Private Route Table AZ2 ID |
| `private_route_table_az3_id` | Private Route Table AZ3 ID |

## Usage

### Basic Example

```hcl
module "vpc" {
  source = "./modules/aws/vpc"

  environment = "production"
  subnet_az1  = "us-east-1a"
  subnet_az2  = "us-east-1b"
  subnet_az3  = "us-east-1c"
}
```

### Example with Custom CIDRs

```hcl
module "vpc" {
  source = "./modules/aws/vpc"

  environment    = "staging"
  aws_region     = "sa-east-1"
  vpc_cidr_block = "172.16.0.0/16"

  subnet_az1 = "sa-east-1a"
  subnet_az2 = "sa-east-1b"
  subnet_az3 = "sa-east-1c"

  # Public Subnets
  public_subnet_az1_cidr = "172.16.0.0/24"
  public_subnet_az2_cidr = "172.16.1.0/24"
  public_subnet_az3_cidr = "172.16.2.0/24"

  # Private Subnets
  private_subnet_az1_cidr = "172.16.10.0/24"
  private_subnet_az2_cidr = "172.16.11.0/24"
  private_subnet_az3_cidr = "172.16.12.0/24"

  # Database Subnets
  database_subnet_az1_cidr = "172.16.20.0/24"
  database_subnet_az2_cidr = "172.16.21.0/24"
  database_subnet_az3_cidr = "172.16.22.0/24"
}
```

### Referencing Outputs in Other Modules

```hcl
# Using VPC in an EKS module
module "eks" {
  source = "./modules/aws/eks"

  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnet_ids
}

# Using for RDS
module "rds" {
  source = "./modules/aws/rds"

  vpc_id          = module.vpc.vpc_id
  database_subnets = module.vpc.database_subnet_ids
}

# Using for ALB
module "alb" {
  source = "./modules/aws/alb"

  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnet_ids
}
```

## Traffic Flow

### Public Subnets
```
Internet ←→ Internet Gateway ←→ Public Subnets
```
- Resources with public IP can receive and send traffic directly to/from internet
- Ideal for: Load Balancers, Bastion Hosts, NAT Gateways

### Private Subnets
```
Private Subnets → NAT Gateway → Internet Gateway → Internet
```
- Resources can **only send** traffic to internet (do not receive direct connections)
- Each AZ uses its own NAT Gateway for high availability
- Ideal for: Applications, Workers, Containers

### Database Subnets
```
Database Subnets ←→ Private Subnets (internal traffic only)
```
- **No internet access** in either direction
- Fully isolated for maximum security
- Ideal for: RDS, ElastiCache, DocumentDB

## Tagging Strategy

All resources are tagged with:

| Tag | Description |
|-----|-------------|
| `Name` | Descriptive resource name |
| `Environment` | Environment (dev, staging, prod) |
| `Type` | Subnet type (Public, Private, Database) |
| `Tier` | Architecture layer (Public, Application, Database) |
| `ManagedBy` | Indicates managed by Terraform |

## Cost Considerations

| Resource | Estimated Cost (us-east-1) |
|----------|---------------------------|
| NAT Gateway | ~$32/month per gateway + $0.045/GB processed |
| Elastic IP | Free when in use, $3.60/month if unallocated |
| VPC | Free |
| Subnets | Free |

**Total Estimate**: ~$100-150/month for 3 NAT Gateways (excluding traffic)

### Cost Optimization

For development/staging environments, consider:

1. **Use only 1 NAT Gateway**: Modify the module to create only 1 shared NAT
2. **VPC Endpoints**: Uncomment the S3 endpoint in `main.tf` to reduce NAT traffic
3. **NAT Instance**: For dev, use an EC2 instance as NAT instead of NAT Gateway

## Security

### Implemented Best Practices

- **Layer isolation**: Database without internet access
- **Private DNS enabled**: Allows internal name resolution
- **Public IP only in public subnets**: Private and database subnets do not expose public IPs
- **NAT Gateway per AZ**: Failure in one AZ does not affect connectivity of others

### Additional Recommendations

After provisioning the VPC, consider adding:

1. **Security Groups**: Instance-level access control
2. **Network ACLs**: Stateless firewall at subnet level
3. **VPC Flow Logs**: Network traffic auditing
4. **AWS WAF**: Web attack protection (if using ALB)


