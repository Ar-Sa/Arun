
resource "opentelekomcloud_vpc_v1" "vpc_v1" {
  name = "${var.vpc_name}"
  cidr = "${var.vpc_cidr}"
}
resource "opentelekomcloud_vpc_subnet_v1" "subnet" {
  count= "${length(split(",",var.array[0]))}"
  name= "${element(split(",",var.array[0]), count.index)}"
  #name = "${var.subnet_name}"
  cidr = "${element(split(",",var.array[1]), count.index)}"
  gateway_ip = "${element(split(",",var.array[2]), count.index)}"  
 vpc_id = "${opentelekomcloud_vpc_v1.vpc_v1.id}"
}

output "output1"{
    value= "${length(split(",",var.array[0]))}"
    #value="${element(split(",",var.ids), count.index)}"
} 

output "output2"{
    value="${element(split(",",var.array[0]), 0)}"
} 
 