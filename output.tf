output "secret_names" {
  value = module.secret_manager.secret_names
  description = "Secret name"
}

output "secret_versions" {
  value = module.secret_manager.secret_versions
  description = "The name list of Secret Versions"
}

output "roles" {
  value       = module.secret_manager_iam.roles
  description = "Roles which were assigned to members."
}

output "members" {
  value       = module.secret_manager_iam.members
  description = "Members which were bound to the Secret Manager Secrets."
}
