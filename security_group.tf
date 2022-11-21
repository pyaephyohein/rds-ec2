resource "aws_security_group" "public_ec2_sg" {
  // Basic details like the name and description of the SG
  name        = "public_ec2_sg"
  description = "Security group for rds_test web servers"
  // We want the SG to be in the "rds_test_vpc" VPC
  vpc_id      = aws_vpc.rds_test_vpc.id

  // The first requirement we need to meet is "EC2 instances should 
  // be accessible anywhere on the internet via HTTP." So we will 
  // create an inbound rule that allows all traffic through
  // TCP port 80.
  ingress {
    description = "Allow all traffic through HTTP"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // The second requirement we need to meet is "Only you should be 
  // "able to access the EC2 instances via SSH." So we will create an 
  // inbound rule that allows SSH traffic ONLY from your IP address
  ingress {
    description = "Allow SSH from my computer"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    // This is using the variable "my_ip"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // This outbound rule is allowing all outbound traffic
  // with the EC2 instances
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Here we are tagging the SG with the name "public_ec2_sg"
  tags = {
    Name = "public_ec2_sg"
  }
}

// Create a security group for the RDS instances called "rds_test_db_sg"
resource "aws_security_group" "rds_test_db_sg" {
  // Basic details like the name and description of the SG
  name        = "rds_test_db_sg"
  description = "Security group for rds_test databases"
  // We want the SG to be in the "rds_test_vpc" VPC
  vpc_id      = aws_vpc.rds_test_vpc.id

  // The third requirement was "RDS should be on a private subnet and 	
  // inaccessible via the internet." To accomplish that, we will 
  // not add any inbound or outbound rules for outside traffic.
  
  // The fourth and finally requirement was "Only the EC2 instances 
  // should be able to communicate with RDS." So we will create an
  // inbound rule that allows traffic from the EC2 security group
  // through TCP port 3306, which is the port that MySQL 
  // communicates through
  ingress {
    description     = "Allow MySQL traffic from only the web sg"
    from_port       = "3306"
    to_port         = "3306"
    protocol        = "tcp"
    security_groups = [aws_security_group.public_ec2_sg.id]
  }

  // Here we are tagging the SG with the name "rds_test_db_sg"
  tags = {
    Name = "rds_test_db_sg"
  }
}
