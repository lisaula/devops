module "rds" {
  source                    = "./rds"

  environment               = var.environment
  subnet_ids                = [var.private_subnet_1a.id,
                               var.private_subnet_1b.id,
                               var.private_subnet_1c.id]
  master_password           = module.secrets.rds_password.result
  vpc_id                    = var.vpc.id

  master_username           = var.master_username
}

module "secrets" {
  source                    = "./secrets"

  environment               = var.environment
  master_username           = var.master_username
  endpoint                  = module.rds.rds_db_instance.endpoint
  port                      = module.rds.rds_db_instance.port
  cluster                   = var.cluster
  aws_rds_endpoint          = module.rds.rds_db_instance.endpoint
  aws_rds_user              = var.master_username
  aws_efs_target            = var.efs.dns_name
  efs_id                    = var.efs.id
  sap_id                    = module.efs.efs_access_point.id
  redis_endpoint            = module.elasticache.redis_endpoint
  redis_port                = module.elasticache.redis_port
}

module "efs" {
  source                    = "./efs"

  environment               = var.environment
  efs                       = var.efs
}

module "elasticache" {
  source                    = "./elasticache"

  environment               = var.environment
  vpc_id                    = var.vpc.id
  subnet_ids                = [var.private_subnet_1a.id,
                               var.private_subnet_1b.id,
                               var.private_subnet_1c.id]
}
