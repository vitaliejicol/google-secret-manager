output "log_export" {
  description = "Log export output"
  value = {
    filter                 = module.log_export.filter
    log_sink_resource_id   = module.log_export.log_sink_resource_id
    log_sink_resource_name = module.log_export.log_sink_resource_name
    parent_resource_id     = module.log_export.parent_resource_id
    writer_identity        = module.log_export.writer_identity
  }
}

output "destination" {
  description = "Destination export output"
  value = {
    console_link    = module.destination.console_link
    project         = module.destination.project
    resource_name   = module.destination.resource_name
    resource_id     = module.destination.resource_id
    self_link       = module.destination.self_link 
    destination_uri = module.destination.destination_uri
  }  
}
