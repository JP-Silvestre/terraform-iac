locals {
  common_tags = merge(var.additional_tags, {
    Project   = var.project_name
    Owner     = var.owner_name
    ManagedBy = "Terraform"
  })
}

module "network" {
  source = "./modules/network"

  project_name       = var.project_name
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  tags               = local.common_tags
}

module "web_server" {
  source = "./modules/web-server"

  project_name     = var.project_name
  owner_name       = var.owner_name
  instance_type    = var.instance_type
  subnet_id        = module.network.public_subnet_id
  vpc_id           = module.network.vpc_id
  allowed_http_cidr = var.allowed_http_cidr
  tags               = local.common_tags
}
