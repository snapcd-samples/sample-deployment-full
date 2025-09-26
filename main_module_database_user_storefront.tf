resource "snapcd_module" "database_user_storefront" {
  name                     = "database-user-storefront"
  namespace_id             = snapcd_namespace.mock.id
  source_revision          = "main"
  source_url               = "https://github.com/snapcd-samples/mock-module-database-user.git"
  source_subdirectory      = ""
  runner_id                = data.snapcd_runner.sample_full.id
  auto_upgrade_enabled     = true
  auto_reconfigure_enabled = true
  auto_migrate_enabled     = false
  clean_init_enabled       = false
}

# data "snapcd_stack_secret" "storefront_db_user_password" {
#   name      = "storefront-db-user-password"
#   stack_id  = data.snapcd_stack.sample_full.id
# }

resource "snapcd_module_input_from_literal" "db_user_storefront_params" {
  for_each = {
    database_user_name = "storefront_user"
  }
  input_kind    = "Param"
  module_id     = snapcd_module.database_user_storefront.id
  name          = each.key
  literal_value = each.value
  type          = "String"
}

resource "snapcd_module_input_from_secret" "database_user_password" {
  input_kind = "Param"
  module_id  = snapcd_module.database_user_storefront.id
  name       = "database_user_password"
  secret_id  = data.snapcd_stack_secret.storefront_db_user_password.id
  type       = "String"
}

resource "snapcd_module_input_from_output_set" "db_user_storefront_database_dependencies" {
  input_kind       = "Param"
  module_id        = snapcd_module.database_user_storefront.id
  name             = "from_database"
  output_module_id = snapcd_module.database.id
}