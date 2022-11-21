resource "aws_vpc" "rds_test_vpc" {
  // Here we are setting the CIDR block of the VPC
  // to the "vpc_cidr_block" variable
  cidr_block           = var.vpc_cidr_block
  // We want DNS hostnames enabled for this VPC
  enable_dns_hostnames = true

  // We are tagging the VPC with the name "rds_test_vpc"
  tags = {
    Name = "rds_test_vpc"
  }
}