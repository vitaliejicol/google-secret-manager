variable "project_id" {
  type        = string
  description = "The project ID to manage the Secret Manager resources"
}

variable "secret_manager" {
  type = any
  description = "Map of all possible settings to build out the secret-manager. Full list of optionsare available here https://github.com/GoogleCloudPlatform/terraform-google-secret-manager"
  default = {
    secrets = []
    user_managed_replication = {}
    topics = {}
    labels = {}
    add_kms_permissions = []
    add_pubsub_permissions = []
  }
}

variable "secret_manager_iam" {
    type = any
    description = "Map of all possible settings to build out the secret-manager-iam. Full list of optionsare available here https://github.com/terraform-google-modules/terraform-google-iam/tree/v7.5.0/modules/secret_manager_iam"
    default = {
        mode = "additive"
        bindings = {
            "roles/secretmanager.secretAccessor" = [
              "serviceAccount:my-sa@gcp-sa-secretmanager.iam.gserviceaccount.com",
            ]
        }
        conditional_bindings = []
    }
}
