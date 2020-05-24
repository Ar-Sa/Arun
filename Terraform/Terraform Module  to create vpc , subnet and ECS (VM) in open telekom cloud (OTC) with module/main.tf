provider "opentelekomcloud" {
  token    = "${var.token}"
  domain_name = "${var.domain_name}"
  tenant_name = "${var.tenant_name}"
  auth_url    = "https://iam.eu-de.otc.t-systems.com:443/v3"
}


//Call modules  
/*
module "Create-VPC" {
  source = "./modules/VPC"
  vpc_name = "${var.vpc_name}"
  vpc_cidr = "${var.vpc_cidr}"
} 

module "Create-Subnet" {
  source = "./modules/Subnet"
  vpc_name = "${var.vpc_name}"
  Subnet_vpc_cidr = "${var.Subnet_vpc_cidr}"
  SubnetName = "${var.SubnetName}"
  gateway_ip = "${var.gateway_ip}"
} 

*/

module "vnet" {
  source = "./modules/vnet"
  vpc_name = "${var.vpc_name}"
  vpc_cidr = "${var.vpc_cidr}"
  array = "${var.array}"
}


module "vm" {
  source = "./modules/vm"
  ECSName = "${var.ECSName}"
  image_name = "${var.image_name}"
  flavor_name = "${var.flavor_name}"
  key_pair = "${var.key_pair}"
  SubnetName = "${var.SubnetName}"
  vpc_name = "${var.vpc_name}"
}
/*
terraform {
  backend "local" {
    path = "terraformvpc.tfstate"
  }
}

*/

