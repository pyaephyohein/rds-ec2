resource "aws_internet_gateway" "rds_test_igw" {
  // Here we are attaching the IGW to the 
  // rds_test_vpc VPC
  vpc_id = aws_vpc.rds_test_vpc.id

  // We are tagging the IGW with the name rds_test_igw
  tags = {
    Name = "rds_test_igw"
  }
}

// Create a group of public subnets based on the variable subnet_count.public
resource "aws_subnet" "rds_test_public_subnet" {
  // count is the number of resources we want to create
  // here we are referencing the subnet_count.public variable which
  // current assigned to 1 so only 1 public subnet will be created
  count             = var.subnet_count.public
  
  // Put the subnet into the "rds_test_vpc" VPC
  vpc_id            = aws_vpc.rds_test_vpc.id
  
  // We are grabbing a CIDR block from the "public_subnet_cidr_blocks" variable
  // since it is a list, we need to grab the element based on count,
  // since count is 1, we will be grabbing the first cidr block 
  // which is going to be 10.0.1.0/24
  cidr_block        = var.public_subnet_cidr_blocks[count.index]
  
  // We are grabbing the availability zone from the data object we created earlier
  // Since this is a list, we are grabbing the name of the element based on count,
  // so since count is 1, and our region is us-east-2, this should grab us-east-2a
  availability_zone = data.aws_availability_zones.available.names[count.index]

  // We are tagging the subnet with a name of "rds_test_public_subnet_" and
  // suffixed with the count
  tags = {
    Name = "rds_test_public_subnet_${count.index}"
  }
}

// Create a group of private subnets based on the variable subnet_count.private
resource "aws_subnet" "rds_test_private_subnet" {
  // count is the number of resources we want to create
  // here we are referencing the subnet_count.private variable which
  // current assigned to 2, so 2 private subnets will be created
  count             = var.subnet_count.private
  
  // Put the subnet into the "rds_test_vpc" VPC
  vpc_id            = aws_vpc.rds_test_vpc.id
  
  // We are grabbing a CIDR block from the "private_subnet_cidr_blocks" variable
  // since it is a list, we need to grab the element based on count,
  // since count is 2, the first subnet will grab the CIDR block 10.0.101.0/24
  // and the second subnet will grab the CIDR block 10.0.102.0/24
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  
  // We are grabbing the availability zone from the data object we created earlier
  // Since this is a list, we are grabbing the name of the element based on count,
  // since count is 2, and our region is us-east-2, the first subnet should
  // grab us-east-2a and the second will grab us-east-2b
  availability_zone = data.aws_availability_zones.available.names[count.index]

  // We are tagging the subnet with a name of "rds_test_private_subnet_" and
  // suffixed with the count
  tags = {
    Name = "rds_test_private_subnet_${count.index}"
  }
}


resource "aws_db_subnet_group" "rds_test_db_subnet_group" {
  // The name and description of the db subnet group
  name        = "rds_test_db_subnet_group"
  description = "DB subnet group for rds_test"
  
  // Since the db subnet group requires 2 or more subnets, we are going to
  // loop through our private subnets in "rds_test_private_subnet" and
  // add them to this db subnet group
  subnet_ids  = [for subnet in aws_subnet.rds_test_private_subnet : subnet.id]
}
