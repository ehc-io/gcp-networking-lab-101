### Firewall Rules
resource "google_compute_firewall" "allow-ssh-central" {
    provider     = google.new_project
    project      = google_project.project.project_id
    name         = "allow-ssh-central"
    network      = google_compute_network.vpc-central.self_link
    priority     = 1000
    direction    = "INGRESS"
    disabled     = false
    source_ranges = ["0.0.0.0/0"]
    target_tags   = var.network_tags
    allow {
      protocol = "tcp"
      ports    = ["22"]
    }
    depends_on   = [google_compute_network.vpc-central]
}

resource "google_compute_firewall" "allow-ssh-west" {
    provider     = google.new_project
    project      = google_project.project.project_id
    name         = "allow-ssh-west"
    network      = google_compute_network.vpc-west.self_link
    priority     = 1000
    direction    = "INGRESS"
    disabled     = false
    source_ranges = ["0.0.0.0/0"]
    target_tags   = var.network_tags
    allow {
      protocol = "tcp"
      ports    = ["22"]
    }
    depends_on   = [google_compute_network.vpc-west]
}

resource "google_compute_firewall" "allow-ssh-east" {
    provider     = google.new_project
    project      = google_project.project.project_id
    name         = "allow-ssh-east"
    network      = google_compute_network.vpc-east.self_link
    priority     = 1000
    direction    = "INGRESS"
    disabled     = false
    source_ranges = ["0.0.0.0/0"]
    target_tags   = var.network_tags
    allow {
      protocol = "tcp"
      ports    = ["22"]
    }
    depends_on   = [google_compute_network.vpc-east]
}

resource "google_compute_firewall" "allow-all-internal-central" {
    provider     = google.new_project
    project      = google_project.project.project_id
    name         = "allow-all-internal-central"
    network      = google_compute_network.vpc-central.self_link
    priority     = 1000
    direction    = "INGRESS"
    disabled     = false
    source_ranges = ["192.168.0.0/16", "10.0.0.0/8"]
    target_tags   = var.network_tags
    allow {
      protocol = "all"
    }
    depends_on   = [google_compute_network.vpc-central]
}

resource "google_compute_firewall" "allow-all-internal-west" {
    provider     = google.new_project
    project      = google_project.project.project_id
    name         = "allow-all-internal-west"
    network      = google_compute_network.vpc-west.self_link
    priority     = 1000
    direction    = "INGRESS"
    disabled     = false
    source_ranges = ["192.168.0.0/16", "10.0.0.0/8"]
    target_tags   = var.network_tags
    allow {
      protocol = "all"
    }
    depends_on   = [google_compute_network.vpc-west]
}

resource "google_compute_firewall" "allow-all-internal-east" {
    provider     = google.new_project
    project      = google_project.project.project_id
    name         = "allow-all-internal-east"
    network      = google_compute_network.vpc-east.self_link
    priority     = 1000
    direction    = "INGRESS"
    disabled     = false
    source_ranges = ["192.168.0.0/16", "10.0.0.0/8"]
    target_tags   = var.network_tags
    allow {
      protocol = "all"
    }
    depends_on   = [google_compute_network.vpc-east]
}