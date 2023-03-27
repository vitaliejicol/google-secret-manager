# This module has been tested with Terraform 0.13 only.
#
# terraform {
#   required_version = ">= 0.14.5"
#   required_providers {
#     google = ">= 4.8"
#   }
# }

# # Create a slot for the secret in Secret Manager
# resource "google_secret_manager_secret" "secret" {
#   //project   = var.project_id
#   project = "darth-vader-274614"
#   secret_id = var.id
#   labels    = var.labels
#   replication {
#     dynamic "user_managed" {
#       for_each = length(var.replication) > 0 ? [1] : []
#       content {
#         dynamic "replicas" {
#           for_each = var.replication
#           content {
#             location = replicas.key
#             dynamic "customer_managed_encryption" {
#               for_each = toset(compact([replicas.value != null ? lookup(replicas.value, "kms_key_name") : null]))
#               content {
#                 kms_key_name = customer_managed_encryption.value
#               }
#             }
#           }
#         }
#       }
#     }
#     automatic = length(var.replication) > 0 ? null : true
#   }
#   dynamic "topics" {
#     for_each = var.topics

#      content {
#       name = topics.value[0]["name"]
#     }
#   }
#   dynamic "rotation" {
#     for_each = length(var.rotation) > 0 ? [1] : []
#     content {
#       next_rotation_time = lookup(var.rotation["default"], "next_rotation_time", null)
#       rotation_period    = lookup(var.rotation["default"], "rotation_period", null)
#     }
#   }
#     depends_on = [
#       google_pubsub_topic_iam_member.sm_sa_publisher,
#       //google_pubsub_topic.example
#     ]
# }

# resource "google_pubsub_topic_iam_member" "sm_sa_publisher" {
#   //project = var.project_id
#   project = "darth-vader-274614"
#   role    = "roles/pubsub.publisher"
#   member  = "serviceAccount:${google_project_service_identity.secretmanager_identity.email}"
#   //member = "serviceAccount:my-service-account@darth-vader-274614.iam.gserviceaccount.com"
#   topic   = var.add_pubsub_permissions
#   //topic = google_pubsub_topic.example.name
# }

# Store actual secret as the latest version if it has been provided.
# resource "google_secret_manager_secret_version" "secret" {
#   secret      = google_secret_manager_secret.secret.id
#   secret_data = var.secret
#   depends_on = [
#     google_secret_manager_secret.secret
#   ]
# }

# # Allow the supplied accounts to read the secret value from Secret Manager
# # Note: this module is non-authoritative and will not remove or modify this role
# # from accounts that were granted the role outside this module.
# resource "google_secret_manager_secret_iam_member" "secret" {
#   for_each  = toset(var.accessors)
#   //project   = var.project_id
#   project = "darth-vader-274614"
#   secret_id = google_secret_manager_secret.secret.secret_id
#   role      = "roles/secretmanager.secretAccessor"
#   member    = "user:myemail@gmail.com"
# }

resource "google_project_service_identity" "secretmanager_identity" {
  provider = google-beta
  //project  = var.project_id ##value to be passed over by the upstream module
  project = "darth-vader-274614"
  service  = "secretmanager.googleapis.com"
}

module "secret-manager" {
  source  = "GoogleCloudPlatform/secret-manager/google"
  version = "~> 0.1"
  project_id = "darth-vader-274614"
  secrets = [
    {
      name                     = "secret-1" ##to be passed over by the up-stream module
      automatic_replication    = false
      secret_data              = "secret informationewq" ##to be determined how fetch the secret value
    }
  ]
}

module "secret_manager_iam" {
  source  = "terraform-google-modules/iam/google//modules/secret_manager_iam"
  //project = "gcp-project-id" ##value to be passed over by the upstream module
  project = "darth-vader-274614"
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
