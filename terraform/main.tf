module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  cluster_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
}

module "eks" {
  source = "./modules/eks"

  cluster_name            = var.project_name
  cluster_version         = var.cluster_version
  subnet_ids              = module.vpc.all_subnet_ids
  node_subnet_ids         = module.vpc.private_subnet_ids
  endpoint_public_access  = var.endpoint_public_access

  node_instance_types = var.node_instance_types
  node_desired_size   = var.node_desired_size
  node_min_size       = var.node_min_size
  node_max_size       = var.node_max_size
  node_capacity_type  = var.node_capacity_type

  depends_on = [module.vpc]
}
