variable "project_id" {
  type        = string
  description = "The project ID to manage the Secret Manager resources"
}
variable "log_export" {
  type = any
  description = "Map of all possible settings to build out the log-export. Full list of optionsare available here https://github.com/terraform-google-modules/terraform-google-log-export"
  default = {
    destination_uri = {}
    filter = "severity >= ERROR"
    include_children = false
    log_sink_name = "storage_example_logsink"
    parent_resource_id = "sample-project"
    parent_resource_type = "project"
    unique_writer_identity = false
    bigquery_options = null
    exclusions = []
  }
}

variable "destination" {
  type = any
  description = "Map of all possible settings to build out the log-export. Full list of optionsare available here https://github.com/terraform-google-modules/terraform-google-log-export"
  default = {
    log_sink_writer_identity = {}
    storage_bucket_name = "ssample_storage_bucket"
    location = "US"
    
    storage_class = "STANDARD"
    storage_bucket_labels = {}
    uniform_bucket_level_access= true
    lifecycle_rules = []
    force_destroy = false
    retention_policy = null
    versioning = false
    kms_key_name = null
  }
}
