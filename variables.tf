variable "project_id" { 
    default = "<PROJECT-ID>"
}

variable "billing_account" {
    default = "<BILLING-ID>"
}

variable "google_folder" {
    default = "folders/<FOLDER-ID>"
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

variable "homeclaro" {
    default = "187.35.15.198/32"
}
variable "pods_cidr" {
    default = "10.0.0.0/22"
}
variable "services_cidr" {
    default = "10.0.4.0/24"
}
variable "cloudrun_cidr" {
    default = "10.0.5.0/24"
}
variable "master_cidr" {
    default = "10.0.7.0/28"
}
variable "cluster_name" {
    default = "k8s-c3rM"
}

locals {
  resource_labels = {
    env         = "netlabs"
    repo        = "GCP-Terraform-Snippets"
    terraform   = "true"
  }
}