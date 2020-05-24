variable "token" {
     default ="MIIEHAYJKoZIhvcNAQcCoIIEDTCCBAkCAQExDTALBglghkgBZQMEAgEwggHqBgkqhkiG9w0BBwGgggHbBIIB13sidG9rZW4iOnsiZXhwaXJlc19hdCI6IjIwMTktMDYtMDFUMDk6NTk6MjAuMTk1MDAwWiIsIm1ldGhvZHMiOlsibWFwcGVkIl0sImlzc3VlZF9hdCI6IjIwMTktMDUtMzFUMDk6NTk6MjAuMTk1MDAwWiIsInVzZXIiOnsiT1MtRkVERVJBVElPTiI6eyJpZGVudGl0eV9wcm92aWRlciI6eyJpZCI6IkVZREVWYXV0b21hdGlvbiJ9LCJwcm90b2NvbCI6eyJpZCI6InNhbWwifSwiZ3JvdXBzIjpbeyJuYW1lIjoiSVQtT1RDQURNSU5fTVNQMDEtVGVhbSIsImlkIjoiNDlhNTdmYjk3ZDAyNDdhM2E2MmUyMmNjZTFlYjhiZWIifV19LCJkb21haW4iOnsibmFtZSI6Ik9UQy1FVS1ERS0wMDAwMDAwMDAwMTAwMDAzMDM5MCIsImlkIjoiOWQ4NjliYzUyZjMwNGFhY2E5MzE4MmUzZWYyY2FhMWMifSwibmFtZSI6IkFydW4gTSBTYWJhbGUgVVMwMTU1NzMwMDgtTVNQMDEiLCJpZCI6IjRRbEFBME1BRkRrTThuRHFRcklxMTAwTmg1TGZNUFVwIn19fTGCAgUwggIBAgEBMFwwVzELMAkGA1UEBhMCVVMxDjAMBgNVBAgMBVVuc2V0MQ4wDAYDVQQHDAVVbnNldDEOMAwGA1UECgwFVW5zZXQxGDAWBgNVBAMMD3d3dy5leGFtcGxlLmNvbQIBATALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggGAiimxBv+s8SAxHaNdU8zEYZBrW26viHv43HgAFYpP1i5qm+WNJDnDQgBlQH1HbosUEMYVpFkXwcQOFYrYYx6Ra+Y9lBHoHfCBOWvZBgc4RuVMyrRb-Kqdg2h8LbRG6Kn8bp8uG4TnTaK0E4IpntiOzJY7U5LdmkKiA5-UZHVhjQmyx-w61r8O8WeCNKlcvqu+V6PdvjfC2AYOKl7-hXnxFYxYK+5lmGYSzYo2Mavr4ldceiKd5qJ-P+5DWbuibgDmkvNhIJhAVVWGtP5lcCocLz1AJUAprlng5d8eTB09K0YJGsYi3W6pRcfN58EpLPCCtGVj2xdlWtMsBaGfYg-lqKIG44oieaUVV5AJIz9M2E7ASWo434hnWiO6w1jNczyQSYxJ1CwGyyOhjy0nGYhKq6+YEA6zZeNJDFcPRFAE0BgT4rTLka0f40--iAEXH2noDnmHbMMxMQtQwNB44ZuRk3tm7mXzGPKoxQmM0rO1W4-tUzvosxltJwWppdzKAd7J"   
}
variable "domain_name" {
     default="OTC-EU-DE-00000000001000030999"
}
variable "tenant_name" {    
     default="eu-de"
}

variable "vpc_name" {
  default = "TestVPC11"
}

variable "vpc_cidr" {
  default = "192.168.0.0/16"
} 

variable "array" {
    default ={
        "0"="subnet1,subnet2"
        "1"="192.168.1.0/24,192.168.2.0/24"
        "2"="192.168.1.1,192.168.2.1"
        }
        
}

variable "ECSName" {
     default = "TerraformTestVM001"
}

variable "image_name" {
     default = "Enterprise_Windows_STD_2016_KVM_20190213-0"
}

variable "flavor_name" {
     default = "s2.medium.1"
}

variable "key_pair" {
     default = "KeyPair-22b1"
}

variable "SubnetName" {
    default =  "subnet1"
}




