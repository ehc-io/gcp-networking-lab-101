############################################################################
# static routes 
############################################################################
resource "google_compute_route" "vpc-west-to-east" {
    name         = "vpc-west-to-east"
    dest_range   = "192.168.10.0/24"
    network      = google_compute_network.vpc-west.name
    next_hop_vpn_tunnel  = google_compute_vpn_tunnel.tunnel1.id
    priority     = 1000
}
resource "google_compute_route" "vpc-west-to-datastream" {
    name         = "vpc-west-to-datastream"
    dest_range   = "10.0.10.0/24"
    network      = google_compute_network.vpc-west.name
    next_hop_vpn_tunnel  = google_compute_vpn_tunnel.tunnel1.id
    priority     = 1000
}