# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "vpc-${var.environment}-${var.vpc_az}"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "igw-${var.environment}"
    Environment = var.environment
  }
}

# Elastic IPs for NAT Gateways
resource "aws_eip" "nat_az1" {
  domain = "vpc"

  tags = {
    Name        = "eip-nat-${var.environment}-${var.subnet_az1}"
    Environment = var.environment
  }

  depends_on = [aws_internet_gateway.main]
}

# resource "aws_eip" "nat_az2" {
#   domain = "vpc"

#   tags = {
#     Name        = "eip-nat-${var.environment}-${var.subnet_az2}"
#     Environment = var.environment
#   }

#   depends_on = [aws_internet_gateway.main]
# }

# resource "aws_eip" "nat_az3" {
#   domain = "vpc"

#   tags = {
#     Name        = "eip-nat-${var.environment}-${var.subnet_az3}"
#     Environment = var.environment
#   }

#   depends_on = [aws_internet_gateway.main]
# }


# Subnets Public
resource "aws_subnet" "public_az1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_az1_cidr
  availability_zone       = var.subnet_az1
  map_public_ip_on_launch = true

  tags = {
    Name        = "public-subnet-${var.environment}-${var.subnet_az1}"
    Type        = "Public"
    Environment = var.environment
    Tier        = "Public"
  }
}

resource "aws_subnet" "public_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_az2_cidr
  availability_zone       = var.subnet_az2
  map_public_ip_on_launch = true

  tags = {
    Name        = "public-subnet-${var.environment}-${var.subnet_az2}"
    Type        = "Public"
    Environment = var.environment
    Tier        = "Public"
  }
}

resource "aws_subnet" "public_az3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_az3_cidr
  availability_zone       = var.subnet_az3
  map_public_ip_on_launch = true

  tags = {
    Name        = "public-subnet-${var.environment}-${var.subnet_az3}"
    Type        = "Public"
    Environment = var.environment
    Tier        = "Public"
  }
}


# Subnets Private
resource "aws_subnet" "private_az1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_az1_cidr
  availability_zone = var.subnet_az1

  tags = {
    Name        = "private-subnet-${var.environment}-${var.subnet_az1}"
    Type        = "Private"
    Environment = var.environment
    Tier        = "Application"
  }
}

resource "aws_subnet" "private_az2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_az2_cidr
  availability_zone = var.subnet_az2

  tags = {
    Name        = "private-subnet-${var.environment}-${var.subnet_az2}"
    Type        = "Private"
    Environment = var.environment
    Tier        = "Application"
  }
}

resource "aws_subnet" "private_az3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_az3_cidr
  availability_zone = var.subnet_az3

  tags = {
    Name        = "private-subnet-${var.environment}-${var.subnet_az3}"
    Type        = "Private"
    Environment = var.environment
    Tier        = "Application"
  }
}

# Subnets Database
resource "aws_subnet" "database_az1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.database_subnet_az1_cidr
  availability_zone = var.subnet_az1

  tags = {
    Name        = "database-subnet-${var.environment}-${var.subnet_az1}"
    Type        = "Database"
    Environment = var.environment
    Tier        = "Database"
  }
}

resource "aws_subnet" "database_az2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.database_subnet_az2_cidr
  availability_zone = var.subnet_az2

  tags = {
    Name        = "database-subnet-${var.environment}-${var.subnet_az2}"
    Type        = "Database"
    Environment = var.environment
    Tier        = "Database"
  }
}

resource "aws_subnet" "database_az3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.database_subnet_az3_cidr
  availability_zone = var.subnet_az3

  tags = {
    Name        = "database-subnet-${var.environment}-${var.subnet_az3}"
    Type        = "Database"
    Environment = var.environment
    Tier        = "Database"
  }
}

# NAT Gateways
resource "aws_nat_gateway" "az1" {
  allocation_id = aws_eip.nat_az1.id
  subnet_id     = aws_subnet.public_az1.id

  tags = {
    Name        = "nat-${var.environment}-${var.subnet_az1}"
    Environment = var.environment
  }

  depends_on = [aws_internet_gateway.main]
}

# resource "aws_nat_gateway" "az2" {
#   allocation_id = aws_eip.nat_az2.id
#   subnet_id     = aws_subnet.public_az2.id

#   tags = {
#     Name        = "nat-${var.environment}-${var.subnet_az2}"
#     Environment = var.environment
#   }

#   depends_on = [aws_internet_gateway.main]
# }

# resource "aws_nat_gateway" "az3" {
#   allocation_id = aws_eip.nat_az3.id
#   subnet_id     = aws_subnet.public_az3.id

#   tags = {
#     Name        = "nat-${var.environment}-${var.subnet_az3}"
#     Environment = var.environment
#   }

#   depends_on = [aws_internet_gateway.main]
# }

# Route Table Public
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "rt-public-${var.environment}"
    Type        = "Public"
    Environment = var.environment
  }
}

# Route Tables Private
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.az1.id
  }

  tags = {
    Name        = "rt-private-${var.environment}-${var.subnet_az1}"
    Type        = "Private"
    Environment = var.environment
  }
}

# resource "aws_route_table" "private_az2" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.az1.id
#   }

#   tags = {
#     Name        = "rt-private-${var.environment}-${var.subnet_az2}"
#     Type        = "Private"
#     Environment = var.environment
#   }
# }

# resource "aws_route_table" "private_az3" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.az1.id
#   }

#   tags = {
#     Name        = "rt-private-${var.environment}-${var.subnet_az3}"
#     Type        = "Private"
#     Environment = var.environment
#   }
# }

# Route Table Database
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.az1.id
  }

  tags = {
    Name        = "rt-database-${var.environment}"
    Type        = "Database"
    Environment = var.environment
  }
}

# Route Table Associations - Public
resource "aws_route_table_association" "public_az1" {
  subnet_id      = aws_subnet.public_az1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_az2" {
  subnet_id      = aws_subnet.public_az2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_az3" {
  subnet_id      = aws_subnet.public_az3.id
  route_table_id = aws_route_table.public.id
}

# Route Table Associations - Private
resource "aws_route_table_association" "private_az1" {
  subnet_id      = aws_subnet.private_az1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_az2" {
  subnet_id      = aws_subnet.private_az2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_az3" {
  subnet_id      = aws_subnet.private_az3.id
  route_table_id = aws_route_table.private.id
}

# Route Table Associations - Database
resource "aws_route_table_association" "database_az1" {
  subnet_id      = aws_subnet.database_az1.id
  route_table_id = aws_route_table.database.id
}

resource "aws_route_table_association" "database_az2" {
  subnet_id      = aws_subnet.database_az2.id
  route_table_id = aws_route_table.database.id
}

resource "aws_route_table_association" "database_az3" {
  subnet_id      = aws_subnet.database_az3.id
  route_table_id = aws_route_table.database.id
}

# VPC Endpoints (Optional - Reduces NAT costs)
resource "aws_vpc_endpoint" "s3" {
  count = var.enable_s3_endpoint ? 1 : 0

  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.s3"

  route_table_ids = [
    aws_route_table.private.id,
    aws_route_table.database.id
  ]

  tags = {
    Name        = "s3-endpoint-${var.environment}"
    Environment = var.environment
  }
}