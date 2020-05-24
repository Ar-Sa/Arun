provider "opentelekomcloud" {
  token    = "${var.token}"
  domain_name = "${var.domain_name}"
  tenant_name = "${var.tenant_name}"
  auth_url    = "https://iam.eu-de.otc.t-systems.com:443/v3"
}


//Data Source

data "opentelekomcloud_vpc_v1" "vpc" {
  name = "${var.vpc_name}"
} 
data "opentelekomcloud_vpc_subnet_v1" "subnet_v1" {
  //id = "${var.Subnet_id}"
  name = "${var.SubnetName}"
  vpc_id = "${data.opentelekomcloud_vpc_v1.vpc.id}"
} 

resource "opentelekomcloud_compute_instance_v2" "basic" {
  name            = "${var.ECSName}"
  image_name        = "${var.image_name}"
  flavor_name       = "${var.flavor_name}"
  key_pair        = "${var.key_pair}"
  security_groups = ["default"]
  metadata {
    this = "that"
  }
  tag {
    OTCWORKLOAD="${var.WORKLOAD}"
    OTCSERVICELINE="${var.SERVICELINE}"
    OTCAPPNAME="${var.APPNAME}"
    OTCPHYSICALREGION="${var.PHYSICALREGION}"
    OTCEYREGION="${var.EYREGION}"
    OTCOWNER="${var.OWNER}"
    OTCCHARGECODE="${var.CHARGECODE}"
    OTCAPPTYPE="${var.APPTYPE}"
    OTCTECHCONTACTS="${var.TECHCONTACTS}"
    OTCACCESSEDVIAINTERNET="${var.ACCESSEDVIAINTERNET}"
  }

  network {
    uuid = "${data.opentelekomcloud_vpc_subnet_v1.subnet_v1.id}"
    //name = "${var.vpc_name}"
  }

}