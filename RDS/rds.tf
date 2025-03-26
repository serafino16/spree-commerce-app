provider "aws" {
  region = "us-east-1"  
}

resource "aws_kms_key" "rds_key" {
  description = "RDS KMS key for encryption at rest"
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Allow inbound traffic to RDS"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = ["10.0.151.0/24", "10.0.152.0/24"]  

  tags = {
    Name = "RDS Subnet Group"
  }
}

resource "aws_db_parameter_group" "rds_parameter_group" {
  name        = "custom-rds-parameter-group"
  family      = "postgres"  
  description = "Custom parameter group for RDS"

  parameters = {
    max_connections = "500"
    innodb_buffer_pool_size = "1024MB"
    query_cache_size = "256MB"
  }
}

resource "aws_db_instance" "rds_instance" {
  identifier        = "my-production-db"
  engine            = "postgres"  
  engine_version    = "10.18"  
  instance_class    = "db.m5.large"
  allocated_storage = 100  
  max_allocated_storage = 200  
  storage_encrypted = true
  kms_key_id        = aws_kms_key.rds_key.key_id
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  multi_az          = true
  publicly_accessible = false  
  backup_retention_period = 7  
  preferred_backup_window = "07:00-09:00"
  preferred_maintenance_window = "sun:05:00-sun:06:00"
  auto_minor_version_upgrade = true

  db_parameter_group_name = aws_db_parameter_group.rds_parameter_group.name

  tags = {
    Name        = "My Production DB"
    Environment = "production"
  }

  
  iam_database_authentication_enabled = true
}

resource "aws_rds_cluster_parameter_group" "rds_cluster_parameter_group" {
  name        = "custom-rds-cluster-parameter-group"
  family      = "Postgres"  
  description = "Custom parameter group for PostgreSQL Cluster"

  parameters = {
    innodb_flush_log_at_trx_commit = "2"
    sql_mode = "STRICT_TRANS_TABLES"
  }
}


