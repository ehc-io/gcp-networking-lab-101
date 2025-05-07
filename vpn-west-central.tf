### VPN
#
# Gateways
resource "google_compute_ha_vpn_gateway" "ha_gateway_west" {
  region  = var.region3
  name    = "ha-vpn-west"
  network = google_compute_network.vpc-west.id
}
resource "google_compute_ha_vpn_gateway" "ha_gateway_central" {
  region  = var.region3
  name    = "ha-vpn-central"
  network = google_compute_network.vpc-central.id
}

# Router Interfaces & BGP Peers
# West-side
resource "google_compute_router_interface" "router_west_interface1" {
  name       = "router-west-interface1"
  router     = google_compute_router.router-west.name
  region     = var.region3
  ip_range   = "169.254.0.1/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel1.name
}
resource "google_compute_router_peer" "router_west_peer_central1" {
  name                      = "router-west-peer-central1"
  router                    = google_compute_router.router-west.name
  region                    = var.region3
  peer_ip_address           = "169.254.0.2"
  peer_asn                  = 64515
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.router_west_interface1.name
}

resource "google_compute_router_interface" "router_west_interface2" {
  name       = "router-west-interface2"
  router     = google_compute_router.router-west.name
  region     = var.region3
  ip_range   = "169.254.1.2/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel2.name
}

resource "google_compute_router_peer" "router_west_peer_central2" {
  name                      = "router-west-peer-central2"
  router                    = google_compute_router.router-west.name
  region                    = var.region3
  peer_ip_address           = "169.254.1.1"
  peer_asn                  = 64515
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.router_west_interface2.name
}

# Router Interfaces & BGP Peers
# Central
#
resource "google_compute_router_interface" "router_central_interface1" {
  name       = "router-central-interface1"
  router     = google_compute_router.router-central.name
  region     = var.region3
  ip_range   = "169.254.0.2/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel3.name
}

resource "google_compute_router_peer" "router_central_peer_west1" {
  name                      = "router-central-peer-west1"
  router                    = google_compute_router.router-central.name
  region                    = var.region3
  peer_ip_address           = "169.254.0.1"
  peer_asn                  = 64514
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.router_central_interface1.name
}

resource "google_compute_router_interface" "router_central_interface2" {
  name       = "router-central-interface2"
  router     = google_compute_router.router-central.name
  region     = var.region3
  ip_range   = "169.254.1.1/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel4.name
}

resource "google_compute_router_peer" "router_central_peer_west2" {
  name                      = "router-central-peer-west2"
  router                    = google_compute_router.router-central.name
  region                    = var.region3
  peer_ip_address           = "169.254.1.2"
  peer_asn                  = 64514
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.router_central_interface2.name
}

# Tunnels
# 
resource "google_compute_vpn_tunnel" "tunnel1" {
  name                  = "ha-vpn-tunnel1"
  region                = var.region3
  vpn_gateway           = google_compute_ha_vpn_gateway.ha_gateway_west.id
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.ha_gateway_central.id
  shared_secret         = "wXLyvxPPDWoyW9YAbq49gh3-7UNyfHu8W*vc*WYi"
  router                = google_compute_router.router-west.id
  vpn_gateway_interface = 0
}

resource "google_compute_vpn_tunnel" "tunnel2" {
  name                  = "ha-vpn-tunnel2"
  region                = var.region3
  vpn_gateway           = google_compute_ha_vpn_gateway.ha_gateway_west.id
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.ha_gateway_central.id
  shared_secret         = "wXLyvxPPDWoyW9YAbq49gh3-7UNyfHu8W*vc*WYi"
  router                = google_compute_router.router-west.id
  vpn_gateway_interface = 1
}

resource "google_compute_vpn_tunnel" "tunnel3" {
  name                  = "ha-vpn-tunnel3"
  region                = var.region3
  vpn_gateway           = google_compute_ha_vpn_gateway.ha_gateway_central.id
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.ha_gateway_west.id
  shared_secret         = "wXLyvxPPDWoyW9YAbq49gh3-7UNyfHu8W*vc*WYi"
  router                = google_compute_router.router-central.id
  vpn_gateway_interface = 0
}

resource "google_compute_vpn_tunnel" "tunnel4" {
  name                  = "ha-vpn-tunnel4"
  region                = var.region3
  vpn_gateway           = google_compute_ha_vpn_gateway.ha_gateway_central.id
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.ha_gateway_west.id
  shared_secret         = "wXLyvxPPDWoyW9YAbq49gh3-7UNyfHu8W*vc*WYi"
  router                = google_compute_router.router-central.id
  vpn_gateway_interface = 1
}

