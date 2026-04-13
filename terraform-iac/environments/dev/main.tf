module "vpc" {
  source = "../../modules/vpc"

  cidr_block          = "10.1.0.0/16"
  public_subnet_cidr  = "10.1.1.0/24"
  private_subnet_cidr = "10.1.2.0/24"
  availability_zone   = "us-east-1a"
}

module "security" {
  source = "../../modules/security"
  vpc_id = module.vpc.vpc_id
}

module "compute" {
  source            = "../../modules/compute"
  subnet_id         = module.vpc.public_subnet_id
  security_group_id = module.security.web_sg_id
}

module "database" {
  source         = "../../modules/database"
  subnet_id      = module.vpc.private_subnet_id
  security_group = module.security.db_sg_id
  db_password    = var.db_password
}
