provider "google" {
  project = var.project_id
}

# Enable required APIs
resource "google_project_service" "compute_api" {
  service = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "container_api" {
  service = "container.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "artifactregistry_api" {
  service = "artifactregistry.googleapis.com"
  disable_on_destroy = false
}

# Create a service account for the GKE cluster
resource "google_service_account" "cluster_sa" {
  account_id   = "cluster-sa"
  display_name = "Cluster Service Account"
  depends_on = [
    google_project_service.container_api
  ]
}

# Grant the service account permission to access the Kubernetes API
resource "google_project_iam_binding" "cluster_sa_iam_binding" {
  project = var.project_id
  role    = "roles/container.admin"
  members = ["serviceAccount:${google_service_account.cluster_sa.email}"]
  depends_on = [
    google_project_service.container_api
  ]
}

# Get the default compute service account
data "google_compute_default_service_account" "default" {
  depends_on = [google_project_service.compute_api]
}

output "gce_service_account" {
  value = data.google_compute_default_service_account.default.email
}

output "gke_service_account" {
  value = google_service_account.cluster_sa.email
}