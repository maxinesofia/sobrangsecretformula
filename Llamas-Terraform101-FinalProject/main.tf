module "networking" {
  source      = "./modules/networking"
  lastname    = var.lastname
  common_tags = local.common_tags
}
module "security" {
  source      = "./modules/security"
  vpc_id      = module.networking.vpc_id
  lastname    = var.lastname
  common_tags = local.common_tags
}
module "compute" {
  source = "./modules/compute"

  frontend_sg_id = module.security.alb_sg_id
  backend_sg_id  = module.security.private_sg_id
  bastion_sg_id  = module.security.bastion_sg_id
  alb_sg_id      = module.security.alb_sg_id

  vpc_id          = module.networking.vpc_id
  public_subnets  = module.networking.public_subnets
  private_subnets = module.networking.private_subnets

  lastname    = var.lastname
  common_tags = local.common_tags
}