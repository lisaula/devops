output "redis_endpoint" {
  value                     = aws_elasticache_cluster._.cache_nodes[0].address
}

output "redis_port" {
  value                     = aws_elasticache_cluster._.cache_nodes[0].port
}
