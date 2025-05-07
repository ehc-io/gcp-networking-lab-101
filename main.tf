# Default provider configuration for project creation
# No project specified here to avoid the dependency cycle
provider "google" {
}

# Creating the GCP project
resource "google_project" "project" {
  name            = var.project_id
  project_id      = var.project_id
  billing_account = var.billing_account
  folder_id       = var.google_folder
}

# Provider configuration that references the created project
provider "google" {
  alias   = "new_project"
  project = google_project.project.project_id
}

# Enable required APIs
resource "google_project_service" "compute_api" {
  provider         = google.new_project
  project          = google_project.project.project_id
  service          = "compute.googleapis.com"
  disable_on_destroy = false
  depends_on       = [google_project.project]
}

resource "google_project_service" "container_api" {
  provider         = google.new_project
  project          = google_project.project.project_id
  service          = "container.googleapis.com"
  disable_on_destroy = false
  depends_on       = [google_project.project]
}

resource "google_project_service" "artifactregistry_api" {
  provider         = google.new_project
  project          = google_project.project.project_id
  service          = "artifactregistry.googleapis.com"
  disable_on_destroy = false
  depends_on       = [google_project.project]
}

# Create a service account for the GKE cluster
resource "google_service_account" "cluster_sa" {
  provider      = google.new_project
  project       = google_project.project.project_id
  account_id    = "cluster-sa"
  display_name  = "Cluster Service Account"
  depends_on    = [
    google_project_service.container_api,
    google_project.project
  ]
}

# Grant the service account permission to access the Kubernetes API
resource "google_project_iam_binding" "cluster_sa_iam_binding" {
  provider   = google.new_project
  project    = google_project.project.project_id
  role       = "roles/container.admin"
  members    = ["serviceAccount:${google_service_account.cluster_sa.email}"]
  depends_on = [
    google_project_service.container_api,
    google_project.project
  ]
}

# Get the default compute service account
data "google_compute_default_service_account" "default" {
  provider   = google.new_project
  project    = google_project.project.project_id
  depends_on = [
    google_project_service.compute_api,
    google_project.project
  ]
}

output "gce_service_account" {
  value = data.google_compute_default_service_account.default.email
}

output "gke_service_account" {
  value = google_service_account.cluster_sa.email
}