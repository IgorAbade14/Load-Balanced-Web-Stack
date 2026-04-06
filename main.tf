module "network" {
  source      = "./modules/network"
  environment = var.environment
}

module "app" {
  source      = "./modules/app"
  environment = var.environment

  vpc_id      = module.network.vpc_id
  subnet_a_id = module.network.subnet_a_id
  subnet_b_id = module.network.subnet_b_id
  lb_sg_id    = module.network.lb_sg_id
  app_sg_id   = module.network.app_sg_id

  ami_ubuntu = var.ami_ubuntu
}