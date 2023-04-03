output "secrets_name_and_versions" {
  description = "Secrets and their versions and member/roles"
  value = {
    secret_names             = module.secret_manager.secret_names
    secret_versions          = module.secret_manager.secret_versions
    secret_roles_and_members = module.secret_manager_iam
  }
  sensitive = false
}
