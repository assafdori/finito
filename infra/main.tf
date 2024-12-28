module "network" {
  source = "./modules/network"
  network_name = var.network.network_name
  region = var.network.region
  vpc_main_cidr_block = var.network.vpc_main_cidr_block
  public_subnets = var.network.public_subnets
  private_subnets = var.network.private_subnets
  database_port = 3306
}
