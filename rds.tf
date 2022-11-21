resource "aws_db_instance" "rds_test_database" {
  identifier             = var.settings.database.identifier
  // The amount of storage in gigabytes that we want for the database. This is 
  // being set by the settings.database.allocated_storage variable, which is 
  // set to 10
  allocated_storage      = var.settings.database.allocated_storage
  
  // The engine we want for our database. This is being set by the 
  // settings.database.engine variable, which is set to "mysql"
  engine                 = var.settings.database.engine
  
  // The version of our database engine. This is being set by the 
  // settings.database.engine_version variable, which is set to "8.0.27"
  engine_version         = var.settings.database.engine_version
  
  // The instance type for our DB. This is being set by the 
  // settings.database.instance_class variable, which is set to "db.t2.micro"
  instance_class         = var.settings.database.instance_class
  
  // This is the name of our database. This is being set by the
  // settings.database.db_name variable, which is set to "rds_test"
  db_name                = var.settings.database.db_name
  
  // The master user of our database. This is being set by the
  // db_username variable, which is being declared in our secrets file
  username               = var.db_username
  
  // The password for the master user. This is being set by the 
  // db_username variable, which is being declared in our secrets file
  password               = var.db_password
  
  // This is the DB subnet group "rds_test_db_subnet_group"
  db_subnet_group_name   = aws_db_subnet_group.rds_test_db_subnet_group.id
  
  // This is the security group for the database. It takes a list, but since
  // we only have 1 security group for our db, we are just passing in the
  // "rds_test_db_sg" security group
  vpc_security_group_ids = [aws_security_group.rds_test_db_sg.id]
  
  // This refers to the skipping final snapshot of the database. It is a 
  // boolean that is set by the settings.database.skip_final_snapshot
  // variable, which is currently set to true.
  skip_final_snapshot    = var.settings.database.skip_final_snapshot
}