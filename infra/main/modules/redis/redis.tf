
resource "aws_elasticache_replication_group" "ssp-redis" {
  replication_group_id       = "${var.global_prefix}-redis"
  description                = "${var.global_prefix} redis"
  node_type                  = "cache.t2.small"
  port                       = 6379
  parameter_group_name       = "default.redis7.cluster.on"
  engine = "redis"
  engine_version = "7.1"
  subnet_group_name = aws_elasticache_subnet_group.ssp-redis.name
  
  security_group_ids = [aws_security_group.redis.id]
  automatic_failover_enabled = true

  num_node_groups         = 3
  replicas_per_node_group = 1

  snapshot_retention_limit = 14
  apply_immediately = true  #prd에서는 false여야 함
}


resource "aws_elasticache_subnet_group" "ssp-redis" {
  name       = "${var.global_prefix}-worker-node"
  subnet_ids = var.subnet_ids
}