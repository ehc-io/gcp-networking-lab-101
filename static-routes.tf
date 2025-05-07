############################################################################
# static routes 
############################################################################
resource "google_compute_route" "vpc-west-to-east" {
    provider        = google.new_project
    project         = google_project.project.project_id
    name            = "vpc-west-to-east"
    dest_range      = "192.168.10.0/24"
    network         = google_compute_network.vpc-west.name
    next_hop_vpn_tunnel = google_compute_vpn_tunnel.tunnel1.id
    priority        = 1000
    depends_on      = [
      google_compute_network.vpc-west,
      google_compute_vpn_tunnel.tunnel1
    ]
}

resource "google_compute_route" "vpc-west-to-datastream" {
    provider        = google.new_project
    project         = google_project.project.project_id
    name            = "vpc-west-to-datastream"
    dest_range      = "10.0.10.0/24"
    network         = google_compute_network.vpc-west.name
    next_hop_vpn_tunnel = google_compute_vpn_tunnel.tunnel1.id
    priority        = 1000
    depends_on      = [
      google_compute_network.vpc-west,
      google_compute_vpn_tunnel.tunnel1
    ]
}