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
  snapshot_identifier    = "arn:aws:rds:us-east-1:767398027423:snapshot:wordpressdbclixx-snapshot"
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  parameter_group_name   = "default.mysql8.0"
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group_name.name
  skip_final_snapshot    = true
  publicly_accessible    = true

}


#----------------------------------------------------------------------
#creating security group for rds instance
#----------------------------------------------------------------------
resource "aws_security_group" "rds-sg" {
  vpc_id      = aws_vpc.vpc_main.id
  name        = "rds-sg"
  description = "Security Group for rds instance in private subnet"

  ingress {
    description     = "Allow ingress traffic for mysql"
    protocol        = "tcp"
    from_port       = 3306
    to_port         = 3306
    security_groups = [aws_security_group.bastion-sg.id, aws_security_group.ecs_sg.id]
  }

  egress {
    description = "Allow all egress traffic"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}