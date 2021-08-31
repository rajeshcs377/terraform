module "network" {
  source             = "./modules/network"
  vpc_cidr           = var.vpc_cidr
  web_subnet_cidr    = var.web_subnet_cidr
  app_subnet_cidr    = var.app_subnet_cidr
  db_subnet_cidr     = var.db_subnet_cidr
  item_count         = var.item_count
  availability_zones = var.availability_zones

}

module "compute" {
  source             = "./modules/compute"
  ami_id             = var.ami_id
  ec2_type           = var.ec2_type
  item_count         = var.item_count
  availability_zones = var.availability_zones
  web-sg-id          = module.network.web-sg-id
  web-subnet-id      = module.network.web-subnet-id
  app-sg-id          = module.network.app-sg-id
  app-subnet-id      = module.network.app-subnet-id
  vpc                = module.network.vpc
  key_name           = module.ssh-key.key_name
  
}


module "ssh-key" {
  source    = "./modules/ssh-key"
  keyname = var.keyname
}