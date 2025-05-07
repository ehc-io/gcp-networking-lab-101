provider "google" {
  project = var.project_id
}

module "project" {
    source              = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/project?ref=v13.0.0"
    name                =  "${var.project_id}"
    billing_account     = var.billing_account
    parent              = var.google_folder
    services = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "artifactregistry.googleapis.com"
    ]
}

# Enable the Container API
resource "google_project_service" "container_api" {
  service = "container.googleapis.com"
}

# # Enable the Artifact Registry API
resource "google_project_service" "artifactregistry_api" {
  service = "artifactregistry.googleapis.com"
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

output "gce_service_account" {
    value = module.project.service_accounts.default.compute
}

output "gke_service_account" {
    value = google_service_account.cluster_sa.email
}
