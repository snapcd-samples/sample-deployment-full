resource "snapcd_module" "app_storefront" {
  name                     = "app-storefront"
  namespace_id             = snapcd_namespace.mock.id
  source_revision          = "main"
  source_url               = "https://github.com/snapcd-samples/mock-module-kubernetes-app-storefront.git"
  source_subdirectory      = ""
  runner_id                = data.snapcd_runner.sample_full.id
  auto_upgrade_enabled     = true
  auto_reconfigure_enabled = true
  auto_migrate_enabled     = false
  clean_init_enabled       = false
}

resource "snapcd_module_input_from_literal" "app_storefront_params_string" {
  for_each = {
    app_url = "https://storefront.demo.com"
  }
  input_kind    = "Param"
  module_id     = snapcd_module.app_storefront.id
  name          = each.key
  literal_value = each.value
  type          = "String"
}

resource "snapcd_module_input_from_literal" "app_storefront_params_notstring" {
  for_each = {
    replicas = 3
  }
  input_kind    = "Param"
  module_id     = snapcd_module.app_storefront.id
  name          = each.key
  literal_value = each.value
  type          = "NotString"
}

resource "snapcd_module_input_from_output_set" "app_storefront_params_from_cluster" {
  input_kind       = "Param"
  module_id        = snapcd_module.app_storefront.id
  name             = "from_cluster"
  output_module_id = snapcd_module.cluster.id
}

resource "snapcd_module_input_from_output_set" "app_storefront_params_from_database_user" {
  input_kind       = "Param"
  module_id        = snapcd_module.app_storefront.id
  name             = "from_database_user"
  output_module_id = snapcd_module.database_user_storefront.id
}

resource "snapcd_module_input_from_output_set" "app_storefront_params_from_database" {
  input_kind       = "Param"
  module_id        = snapcd_module.app_storefront.id
  name             = "from_database"
  output_module_id = snapcd_module.database.id
}

resource "snapcd_module_input_from_secret" "app_storefront_params_database_user_password" {
  input_kind = "Param"
  module_id  = snapcd_module.app_storefront.id
  name       = "database_user_password"
  secret_id  = data.snapcd_stack_secret.storefront_db_user_password.id
  type       = "String"
}