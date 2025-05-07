variable "project_id" { 
    default = "netlab-<ID-STRING>"
}
variable "billing_account" {
    default = "<BILLING-ID>"
}

variable "google_folder" {
    default = "<FOLDER-PATH>"
}

variable "network_cidr_vpc_east" { 
    default = "192.168.10.0/24"
}
variable "network_cidr_vpc_central" { 
    default = "192.168.20.0/24"
}
variable "network_cidr_vpc_west" { 
    default = "192.168.30.0/24"
}

variable "network_ip_i_west" { 
    default = "192.168.30.5"
}
variable "network_ip_i_east" { 
    default = "192.168.10.5"
}
variable "network_ip_i_central" { 
    default = "192.168.20.5"
}

variable "region1" {
    default = "us-east1"
}
variable "region2" {
    default = "us-central1"
}
variable "region3" {
    default = "us-west1"
}

variable "zone1" {
    default = "us-east1-b"
}
variable "zone2" {
    default = "us-central1-a"
}
variable "zone3" {
    default = "us-west1-b"
}

variable "network_tags" {
    default = [ "mgmt", "ssh" ]
}

variable "mgmg-network" {
    default = "<REMOTE-MGMT-IP>"
}

locals {
  resource_labels = {
    env         = "netlabs"
    repo        = "my-repo"
    terraform   = "true"
  }
}