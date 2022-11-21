resource "aws_instance" "public_ec2" {
  // count is the number of instance we want
  // since the variable settings.web_app.cont is set to 1, we will only get 1 EC2
  count                  = var.settings.web_app.count
  
  // Here we need to select the ami for the EC2. We are going to use the
  // ami data object we created called ubuntu, which is grabbing the latest
  // Ubuntu 20.04 ami
  ami                    = data.aws_ami.ubuntu.id
  
  // This is the instance type of the EC2 instance. The variable
  // settings.web_app.instance_type is set to "t2.micro"
  instance_type          = var.settings.web_app.instance_type
  
  // The subnet ID for the EC2 instance. Since "rds_test_public_subnet" is a list
  // of public subnets, we want to grab the element based on the count variable.
  // Since count is 1, we will be grabbing the first subnet in  	
  // "rds_test_public_subnet" and putting the EC2 instance in there
  subnet_id              = aws_subnet.rds_test_public_subnet[count.index].id
  
  // The key pair to connect to the EC2 instance. We are using the "rds_test_kp" key 
  // pair that we created
  key_name               = "x1c7"
  
  // The security groups of the EC2 instance. This takes a list, however we only
  // have 1 security group for the EC2 instances.
  vpc_security_group_ids = [aws_security_group.public_ec2_sg.id]

  // We are tagging the EC2 instance with the name "rds_test_db_" followed by
  // the count index
  tags = {
    Name = "public_ec2_${count.index}"
  }
}

// Create an Elastic IP named "public_ec2_eip" for each
// EC2 instance
resource "aws_eip" "public_ec2_eip" {
	// count is the number of Elastic IPs to create. It is
	// being set to the variable settings.web_app.count which
	// refers to the number of EC2 instances. We want an
	// Elastic IP for every EC2 instance
  count    = var.settings.web_app.count

	// The EC2 instance. Since public_ec2 is a list of 
	// EC2 instances, we need to grab the instance by the 
	// count index. Since the count is set to 1, it is
	// going to grab the first and only EC2 instance
  instance = aws_instance.public_ec2[count.index].id

	// We want the Elastic IP to be in the VPC
  vpc      = true

	// Here we are tagging the Elastic IP with the name
	// "public_ec2_eip_" followed by the count index
  tags = {
    Name = "public_ec2_eip_${count.index}"
  }
}
