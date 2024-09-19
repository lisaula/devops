resource "aws_elasticache_cluster" "_" {
  cluster_id                = "redis-${var.environment}"
  engine                    = "redis"
  node_type                 = "cache.t4g.small"
  num_cache_nodes           = 1
  parameter_group_name      = "default.redis7"
  engine_version            = "7.0"
  subnet_group_name         = aws_elasticache_subnet_group._.name
  security_group_ids        = [aws_security_group._.id]
}
