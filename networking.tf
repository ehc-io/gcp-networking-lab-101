### vpc
resource "google_compute_network" "vpc-east" {
  provider                = google.new_project
  project                 = google_project.project.project_id
  name                    = "vpc-east"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false
  depends_on              = [google_project_service.compute_api]
}

resource "google_compute_network" "vpc-west" {
  provider                = google.new_project
  project                 = google_project.project.project_id
  name                    = "vpc-west"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false
  depends_on              = [google_project_service.compute_api]
}

resource "google_compute_network" "vpc-central" {
  provider                = google.new_project
  project                 = google_project.project.project_id
  name                    = "vpc-central"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false
  depends_on              = [google_project_service.compute_api]
}

### Subnets
resource "google_compute_subnetwork" "east_subnet1" {
  provider      = google.new_project
  project       = google_project.project.project_id
  name          = "east-subnet-1"
  ip_cidr_range = var.network_cidr_vpc_east
  region        = var.region1
  network       = google_compute_network.vpc-east.id
  depends_on    = [google_compute_network.vpc-east]
}

resource "google_compute_subnetwork" "central_subnet1" {
  provider      = google.new_project
  project       = google_project.project.project_id
  name          = "central-subnet-1"
  ip_cidr_range = var.network_cidr_vpc_central
  region        = var.region2
  network       = google_compute_network.vpc-central.id
  depends_on    = [google_compute_network.vpc-central]
  
  # secondary_ip_range = [ {
  #   ip_cidr_range =  var.pods_cidr
  #   range_name = "pods"
  # },
  # {
  #   ip_cidr_range =  var.services_cidr
  #   range_name = "services"
  # },
  # {
  #   ip_cidr_range =  var.cloudrun_cidr
  #   range_name = "cloudrun"
  # },
  # ]
}

resource "google_compute_subnetwork" "west_subnet1" {
  provider      = google.new_project
  project       = google_project.project.project_id
  name          = "west-subnet-1"
  ip_cidr_range = var.network_cidr_vpc_west
  region        = var.region3
  network       = google_compute_network.vpc-west.id
  depends_on    = [google_compute_network.vpc-west]
}

### NAT
resource "google_compute_router_nat" "nat_central" {
    provider    = google.new_project
    project     = google_project.project.project_id
    name        = "nat-central"
    router      = google_compute_router.router_nat_central.name
    region      = var.region2
    nat_ip_allocate_option  = "AUTO_ONLY"
    source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
    log_config {
      enable = true
      filter = "ERRORS_ONLY"
    }
    depends_on  = [google_compute_router.router_nat_central]
}

resource "google_compute_router_nat" "nat_west" {
    provider    = google.new_project
    project     = google_project.project.project_id
    name        = "nat-west"
    router      = google_compute_router.router_nat_west.name
    region      = var.region3
    nat_ip_allocate_option  = "AUTO_ONLY"
    source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
    log_config {
      enable = true
      filter = "ERRORS_ONLY"
    }
    depends_on  = [google_compute_router.router_nat_west]
}

resource "google_compute_router_nat" "nat_east" {
    provider    = google.new_project
    project     = google_project.project.project_id
    name        = "nat-east"
    router      = google_compute_router.router_nat_east.name
    region      = var.region1
    nat_ip_allocate_option  = "AUTO_ONLY"
    source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
    log_config {
      enable = true
      filter = "ERRORS_ONLY"
    }
    depends_on  = [google_compute_router.router_nat_east]
}

### Peering
# resource "google_compute_network_peering" "peering_east_central" {
#   provider     = google.new_project
#   name         = "peering-east-central"
#   network      = google_compute_network.vpc-east.self_link
#   peer_network = google_compute_network.vpc-central.self_link
# }
# resource "google_compute_network_peering" "peering_central_east" {
#   provider     = google.new_project
#   name         = "peering-central-east"
#   network      = google_compute_network.vpc-central.self_link
#   peer_network = google_compute_network.vpc-east.self_link
# }

### Routers
resource "google_compute_router" "router-central" {
  provider  = google.new_project
  project   = google_project.project.project_id
  name      = "router-central"
  region    = var.region3
  network   = google_compute_network.vpc-central.self_link
  bgp {
    asn = 64515
  }
  depends_on = [google_compute_network.vpc-central]
}

resource "google_compute_router" "router_nat_central" {
  provider  = google.new_project
  project   = google_project.project.project_id
  name      = "router-nat-central"
  region    = var.region2
  network   = google_compute_network.vpc-central.self_link
  depends_on = [google_compute_network.vpc-central]
}

resource "google_compute_router" "router_nat_west" {
  provider  = google.new_project
  project   = google_project.project.project_id
  name      = "router-nat-west"
  region    = var.region3
  network   = google_compute_network.vpc-west.self_link
  depends_on = [google_compute_network.vpc-west]
}

resource "google_compute_router" "router-west" {
  provider  = google.new_project
  project   = google_project.project.project_id
  name      = "router-west"
  region    = var.region3
  network   = google_compute_network.vpc-west.self_link
  bgp {
    asn = 64514
  }
  depends_on = [google_compute_network.vpc-west]
}

resource "google_compute_router" "router_nat_east" {
  provider  = google.new_project
  project   = google_project.project.project_id
  name      = "router-nat-east"
  region    = var.region1
  network   = google_compute_network.vpc-east.self_link
  depends_on = [google_compute_network.vpc-east]
}