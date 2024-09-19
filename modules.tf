module "core" {
  source                    = "./modules/core"

  cluster_name              = var.cluster_name
  kubernetes_version        = var.kubernetes_version
  subnet_ids                = [module.network.private_subnet_1a.id,
                               module.network.private_subnet_1b.id,
                               module.network.private_subnet_1c.id,
                               module.network.public_subnet_1a.id,
                               module.network.public_subnet_1b.id,
                               module.network.public_subnet_1c.id]
}

module "network" {
  source                    = "./modules/network"

  cluster_name              = var.cluster_name
  region                    = var.region
  aws_cidr                  = var.aws_cidr
  private_subnet_1a         = var.private_subnet_1a
  private_subnet_1b         = var.private_subnet_1b
  private_subnet_1c         = var.private_subnet_1c
  public_subnet_1a          = var.public_subnet_1a
  public_subnet_1b          = var.public_subnet_1b
  public_subnet_1c          = var.public_subnet_1c
  region_1_a                = var.region_1_a
  region_1_b                = var.region_1_b
  region_1_c                = var.region_1_c
}

module "efs" {
  source                    = "./modules/efs"

  vpc                       = module.network.vpc
  subnet_ids                = [module.network.private_subnet_1a.id,
                               module.network.private_subnet_1b.id,
                               module.network.private_subnet_1c.id]
}

module "master" {
  source                    = "./modules/master"

  cluster                   = module.core.cluster
  efs                       = module.efs.efs
  cluster_name              = var.cluster_name
}

module "node" {
  source = "./modules/node"

  cluster                   = module.core.cluster
  instance_types            = var.instance_types
  desired_size              = var.desired_size
  min_size                  = var.min_size
  max_size                  = var.max_size
  ami_type                  = var.ami_type
  size_disk                 = var.size_disk
  subnet_ids                = [module.network.private_subnet_1a.id,
                               module.network.private_subnet_1b.id,
                               module.network.private_subnet_1c.id]
}

module "instances" {
  source                    = "./modules/instances"
  ami_id_vpn                = var.ami_id_vpn
  instance_types_vpn        = var.instance_types_vpn
  subnet_public_id          = module.network.public_subnet_1a.id
  volume_size               = var.volume_size
  volume_type               = var.volume_type
}

terraform {
  backend "s3" {
    bucket                  = "syllo-devops"
    key                     = "tfstate/terraform.tfstate"
    region                  = "us-east-1"
    profile                 = "tlatech"
    encrypt                 = false
  }
}

# Begin environment-specific modules.

module "development" {
  source                    = "./modules/environment"
  environment               = "development"
  master_username           = var.master_username
  vpc                       = module.network.vpc
  private_subnet_1a         = module.network.private_subnet_1a
  private_subnet_1b         = module.network.private_subnet_1b
  private_subnet_1c         = module.network.private_subnet_1c
  cluster                   = module.core.cluster
  efs                       = module.efs.efs
}

module "production" {
  source                    = "./modules/environment"
  environment               = "production"
  master_username           = var.master_username
  vpc                       = module.network.vpc
  private_subnet_1a         = module.network.private_subnet_1a
  private_subnet_1b         = module.network.private_subnet_1b
  private_subnet_1c         = module.network.private_subnet_1c
  cluster                   = module.core.cluster
  efs                       = module.efs.efs
}
