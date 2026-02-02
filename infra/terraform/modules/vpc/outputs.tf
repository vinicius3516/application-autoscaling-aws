# VPC
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value       = aws_vpc.main.cidr_block
}

# Subnets - Public
output "public_subnet_az1_id" {
  description = "Public subnet AZ1 ID"
  value       = aws_subnet.public_az1.id
}

output "public_subnet_az2_id" {
  description = "Public subnet AZ2 ID"
  value       = aws_subnet.public_az2.id
}

output "public_subnet_az3_id" {
  description = "Public subnet AZ3 ID"
  value       = aws_subnet.public_az3.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [aws_subnet.public_az1.id, aws_subnet.public_az2.id, aws_subnet.public_az3.id]
}

# Subnets - Private
output "private_subnet_az1_id" {
  description = "Private subnet AZ1 ID"
  value       = aws_subnet.private_az1.id
}

output "private_subnet_az2_id" {
  description = "Private subnet AZ2 ID"
  value       = aws_subnet.private_az2.id
}

output "private_subnet_az3_id" {
  description = "Private subnet AZ3 ID"
  value       = aws_subnet.private_az3.id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [aws_subnet.private_az1.id, aws_subnet.private_az2.id, aws_subnet.private_az3.id]
}

# Subnets - Database
output "database_subnet_az1_id" {
  description = "Database subnet AZ1 ID"
  value       = aws_subnet.database_az1.id
}

output "database_subnet_az2_id" {
  description = "Database subnet AZ2 ID"
  value       = aws_subnet.database_az2.id
}

output "database_subnet_az3_id" {
  description = "Database subnet AZ3 ID"
  value       = aws_subnet.database_az3.id
}

output "database_subnet_ids" {
  description = "List of database subnet IDs"
  value       = [aws_subnet.database_az1.id, aws_subnet.database_az2.id, aws_subnet.database_az3.id]
}

# Internet Gateway
output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.main.id
}

# NAT Gateways
output "nat_gateway_az1_id" {
  description = "NAT Gateway AZ1 ID"
  value       = aws_nat_gateway.az1.id
}

# output "nat_gateway_az2_id" {
#   description = "NAT Gateway AZ2 ID"
#   value       = aws_nat_gateway.az2.id
# }

# output "nat_gateway_az3_id" {
#   description = "NAT Gateway AZ3 ID"
#   value       = aws_nat_gateway.az3.id
# }

# Route Tables
output "public_route_table_id" {
  description = "Public route table ID"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "Private route table ID"
  value       = aws_route_table.private.id
}

# output "private_route_table_az2_id" {
#   description = "Private route table AZ2 ID"
#   value       = aws_route_table.private_az2.id
# }

# output "private_route_table_az3_id" {
#   description = "Private route table AZ3 ID"
#   value       = aws_route_table.private_az3.id
# }