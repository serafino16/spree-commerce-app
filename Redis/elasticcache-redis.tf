resource "aws_elasticache_replication_group" "redis_standalone" {
  replication_group_id          = "redis-standalone"
  replication_group_description = "Standalone Redis Cluster"
  node_type                     = "cache.t3.micro"  
  engine                        = "redis"
  engine_version                = "6.x"
  num_cache_clusters            = 1  
  parameter_group_name          = "default.redis6.x"
  subnet_group_name             = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids           = [aws_security_group.redis_sg.id]
  automatic_failover            = false
  tags = {
    Name = "Redis-Standalone"
  }

  maintenance_window = "sun:05:00-sun:09:00"
}

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-subnet-group"
  subnet_ids = [aws_subnet.redis_subnet.id]

  tags = {
    Name = "Redis-Subnet-Group"
  }
}
