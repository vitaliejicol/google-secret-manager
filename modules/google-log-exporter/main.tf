module "log_export" {
  source  = "terraform-google-modules/log-export/google"
  version = "~> 7.0"
  destination_uri        = module.destination.destination_uri
  filter                 = lookup(var.log_export, "filter", {})
  log_sink_name          = lookup(var.log_export, "log_sink_name", {})
  parent_resource_id     = lookup(var.log_export, "parent_resource_id", {})
  parent_resource_type   = lookup(var.log_export, "parent_resource_type", {})
  unique_writer_identity = lookup(var.log_export, "unique_writer_identity", {})
  include_children       = lookup(var.log_export, "include_children", {})
  bigquery_options       = lookup(var.log_export, "bigquery_options", {})
  exclusions             = lookup(var.log_export, "exclusions", [])

}

module "destination" {
  source  = "terraform-google-modules/log-export/google//modules/storage"
  version = "~> 7.0"
  project_id                  = var.project_id
  storage_bucket_name         = lookup(var.destination, "storage_bucket_name", {})
  storage_class               = lookup(var.destination, "storage_class", {})
  storage_bucket_labels       = lookup(var.destination, "storage_bucket_labels", [])
  uniform_bucket_level_access = lookup(var.destination, "uniform_bucket_level_access", {})
  lifecycle_rules             = lookup(var.destination, "lifecycle_rules", {})
  log_sink_writer_identity    = module.log_export.writer_identity
  location                    = lookup(var.destination, "location", {})
  force_destroy               = lookup(var.destination, "force_destroy", {})
  retention_policy            = lookup(var.destination, "retention_policy", {})
  versioning                  = lookup(var.destination, "versioning", {})
  kms_key_name                = lookup(var.destination, "kms_key_name", {})
}
