provider "aws" {
   region = var.aws_region //esta se la pasamos con el apply como variable de entrada
 }


data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_region" "current" {}

module "network-stack1" {
  source = "./module-net"

  vpc_cidr_block = "10.0.0.0/16"
  private_subnet_cidrs = local.private_subnet_cidrs_div_st1  
  public_subnet_cidrs = local.public_subnet_cidrs_div_st1
  availability_zones = local.first_half
}

module "network-stack2" {
  source = "./module-net"

  vpc_cidr_block = "10.1.0.0/16"
  private_subnet_cidrs= local.private_subnet_cidrs_div_st2
  public_subnet_cidrs = local.public_subnet_cidrs_div_st2
  availability_zones = local.second_half
}

module "app-stack1" {
 source = "./module-compu"
 vpc_id = module.network-stack1.vpc_id
 public_subnets = module.network-stack1.public_subnet_ids
 private_subnets = module.network-stack1.private_subnet_ids
}

module "app-stack2" {
 source = "./module-compu"
  vpc_id = module.network-stack2.vpc_id
  public_subnets = module.network-stack2.public_subnet_ids
  private_subnets = module.network-stack2.private_subnet_ids
}


# esto sería para exportar la salida de la salida??
output "module-network-stack1-output" {
  value = module.network-stack1
}
