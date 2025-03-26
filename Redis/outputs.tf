output "redis_endpoint" {
  value = aws_elasticache_replication_group.redis_standalone.primary_endpoint
}

output "redis_cluster_endpoint" {
  value = aws_elasticache_replication_group.redis_cluster.primary_endpoint
}
