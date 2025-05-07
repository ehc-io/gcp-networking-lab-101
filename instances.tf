## Instances
resource "google_compute_instance" "i-central" {
  provider      = google.new_project
  project       = google_project.project.project_id
  name          = "i-central"
  machine_type  = "e2-micro"
  zone          = var.zone2
  tags          = ["ssh"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network     = google_compute_network.vpc-central.id
    subnetwork  = google_compute_subnetwork.central_subnet1.id
    network_ip  = var.network_ip_i_central
  }    

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    email  = data.google_compute_default_service_account.default.email
    scopes = ["cloud-platform"]
  }

  depends_on = [
    google_compute_subnetwork.central_subnet1,
    data.google_compute_default_service_account.default
  ]
}

resource "google_compute_instance" "i-east" {
  provider      = google.new_project
  project       = google_project.project.project_id
  name          = "i-east"
  machine_type  = "e2-micro"
  zone          = var.zone1
  tags          = ["ssh"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network     = google_compute_network.vpc-east.id
    subnetwork  = google_compute_subnetwork.east_subnet1.id
    network_ip  = var.network_ip_i_east
  }    

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    email  = data.google_compute_default_service_account.default.email
    scopes = ["cloud-platform"]
  }

  depends_on = [
    google_compute_subnetwork.east_subnet1,
    data.google_compute_default_service_account.default
  ]
}

resource "google_compute_instance" "i-west" {
  provider      = google.new_project
  project       = google_project.project.project_id
  name          = "i-west"
  machine_type  = "e2-micro"
  zone          = var.zone3
  tags          = ["ssh", "mysql"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network     = google_compute_network.vpc-west.id
    subnetwork  = google_compute_subnetwork.west_subnet1.id
    network_ip  = var.network_ip_i_west
  }    

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    email  = data.google_compute_default_service_account.default.email
    scopes = ["cloud-platform"]
  }

  depends_on = [
    google_compute_subnetwork.west_subnet1,
    data.google_compute_default_service_account.default
  ]
}