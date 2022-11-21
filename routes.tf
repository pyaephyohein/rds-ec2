resource "aws_route_table" "rds_test_public_rt" {
  // Put the route table in the "rds_test_vpc" VPC
  vpc_id = aws_vpc.rds_test_vpc.id

  // Since this is the public route table, it will need
  // access to the internet. So we are adding a route with
  // a destination of 0.0.0.0/0 and targeting the Internet 	 
  // Gateway "rds_test_igw"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rds_test_igw.id
  }
}

// Here we are going to add the public subnets to the 
// "rds_test_public_rt" route table
resource "aws_route_table_association" "public" {
  // count is the number of subnets we want to associate with
  // this route table. We are using the subnet_count.public variable
  // which is currently 1, so we will be adding the 1 public subnet
  count          = var.subnet_count.public
  
  // Here we are making sure that the route table is
  // "rds_test_public_rt" from above
  route_table_id = aws_route_table.rds_test_public_rt.id
  
  // This is the subnet ID. Since the "rds_test_public_subnet" is a 
  // list of the public subnets, we need to use count to grab the
  // subnet element and then grab the id of that subnet
  subnet_id      = 	aws_subnet.rds_test_public_subnet[count.index].id
}

// Create a private route table named "rds_test_private_rt"
resource "aws_route_table" "rds_test_private_rt" {
  // Put the route table in the "rds_test_VPC" VPC
  vpc_id = aws_vpc.rds_test_vpc.id
  
  // Since this is going to be a private route table, 
  // we will not be adding a route
}

// Here we are going to add the private subnets to the
// route table "rds_test_private_rt"
resource "aws_route_table_association" "private" {
  // count is the number of subnets we want to associate with
  // the route table. We are using the subnet_count.private variable
  // which is currently 2, so we will be adding the 2 private subnets
  count          = var.subnet_count.private
  
  // Here we are making sure that the route table is
  // "rds_test_private_rt" from above
  route_table_id = aws_route_table.rds_test_private_rt.id
  
  // This is the subnet ID. Since the "rds_test_private_subnet" is a
  // list of private subnets, we need to use count to grab the
  // subnet element and then grab the ID of that subnet
  subnet_id      = aws_subnet.rds_test_private_subnet[count.index].id
}
