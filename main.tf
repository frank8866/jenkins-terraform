provider "aws" {
  profile = "default"
  region  = "ap-southeast-2"
}

module "network_module" {
  source = "./network_module"
}

module "loadbalancer_module" {
  source       = "./loadbalancer_module"
  public_sg_id = module.network_module.public_sg_id
}

module "autoscaling_module" {
  source = "./autoscaling_module"
  private_sg_id = "${module.network_module.private_sg_id}"
  tg_arn = "${module.loadbalancer_module.tg_arn}"
}