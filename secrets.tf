module "secret_manager" {
  source  = "GoogleCloudPlatform/secret-manager/google"
  version = "~> 0.1"
  project_id               = var.project_id
  secrets                  = lookup(var.secret_manager, "secrets", [])
  user_managed_replication = lookup(var.secret_manager, "user_managed_replication", {})
  topics                   = lookup(var.secret_manager, "topics", {})
  labels                   = lookup(var.secret_manager, "labels", {})
  add_kms_permissions      = lookup(var.secret_manager, "add_kms_permissions", [])
  add_pubsub_permissions   = lookup(var.secret_manager, "add_pubsub_permissions", [])
}

module "secret_manager_iam" {
  source  = "terraform-google-modules/iam/google//modules/secret_manager_iam"
  project              = var.project_id
  secrets              = module.secret_manager.secret_names ##from variable secrets or from module???
  mode                 = lookup(var.secret_manager_iam, "mode", "additive")
  bindings             = lookup(var.secret_manager_iam, "bindings", {})
  conditional_bindings = lookup(var.secret_manager_iam, "conditional_bindings", [])

  depends_on = [
    module.secret_manager
  ]
}
