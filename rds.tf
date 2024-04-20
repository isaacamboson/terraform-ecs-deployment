# creating subnet group name for database creation
resource "aws_db_subnet_group" "db_subnet_group_name" {
  name       = "subnet_group_name"
  subnet_ids = [aws_subnet.private_subnets[2].id, aws_subnet.private_subnets[3].id]
}

# intitiating database instance for clixx application
resource "aws_db_instance" "clixx_app_db_instance" {
  count             = var.stack_controls["rds_create_clixx"] == "Y" ? 1 : 0
  instance_class    = "db.m6gd.large"
  allocated_storage = 20
  iops              = 3000
  engine            = "mysql"
  engine_version    = "8.0.28"
  identifier        = "wordpressdbclixx"
  #   snapshot_identifier = "wordpressdbclixx-snapshot"
  #   snapshot_identifier = "arn:aws:rds:us-east-1:577701061234:snapshot:wordpressdbclixx-ecs-snapshot"
  snapshot_identifier    = "arn:aws:rds:us-east-1:767398027423:snapshot:wordpressdbclixx-snapshot"
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  parameter_group_name   = "default.mysql8.0"
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group_name.name
  skip_final_snapshot    = true
  publicly_accessible    = true

}