provider "aws" {
  region     = var.region
}

#VPC Module
module "vpc" {
  source = "./vpc"
}

# App Modules
module "frontend" {
  source    = "./instances/react-instance"
  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.subnet_id
}

module "backend" {
  source    = "./instances/django-instance"
  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.subnet_id
}
