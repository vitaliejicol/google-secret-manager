resource "google_project_service_identity" "secretmanager_identity" {
  provider = google-beta
  project  = var.project_id ##value to be passed over by the upstream module
  service  = "secretmanager.googleapis.com"
}

module "secret-manager" {
  source  = "GoogleCloudPlatform/secret-manager/google"
  version = "~> 0.1"
  project_id = var.project_id ##value to be passed over by the upstream module
  secrets = [
    {
      name                     = "secret-1" ##to be passed over by the up-stream module
      automatic_replication    = false
      secret_data              = "secret informationew" ##to be determined how fetch the secret value
    }
  ]
}

module "secret_manager_iam" {
  source  = "terraform-google-modules/iam/google//modules/secret_manager_iam"
  project = var.project_id ##value to be passed over by the upstream module
  secrets = module.secret-manager.secret_names
  mode = "additive"

  bindings = {
    "roles/secretmanager.secretAccessor" = [
      "serviceAccount:${google_project_service_identity.secretmanager_identity.email}"
    ]

    "roles/secretmanager.viewer" = [
      "user:myemail@gmail.com"
    ]
  }
  depends_on = [
    module.secret-manager
  ]
}
