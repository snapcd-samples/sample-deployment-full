resource "snapcd_module" "storefront_configuration" {
  name                     = "storefront-configuration"
  namespace_id             = snapcd_namespace.sample.id
  source_revision          = "main"
  source_url               = "https://github.com/snapcd-samples/mock-module-storefront-configuration.git"
  source_subdirectory      = ""
  runner_id                = data.snapcd_runner.sample_full.id
  auto_upgrade_enabled     = true
  auto_reconfigure_enabled = true
  auto_migrate_enabled     = false
  clean_init_enabled       = false
}



resource "snapcd_module_input_from_literal" "storefront_config_params_string" {
  for_each = {
    theme = "modern"
  }
  input_kind    = "Param"
  module_id     = snapcd_module.storefront_configuration.id
  name          = each.key
  literal_value = each.value
  type          = "String"
}

resource "snapcd_module_input_from_secret" "api_key" {
  input_kind = "Param"
  module_id  = snapcd_module.storefront_configuration.id
  name       = "api_key"
  secret_id  = data.snapcd_stack_secret.storefront_api_key.id
  type       = "String"
}

resource "snapcd_module_input_from_output_set" "storefront_dependencies" {
  input_kind       = "Param"
  module_id        = snapcd_module.storefront_configuration.id
  name             = "from_storefront"
  output_module_id = snapcd_module.app_storefront.id
}