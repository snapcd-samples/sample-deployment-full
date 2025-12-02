resource "snapcd_module" "storage" {
  name                     = "storage"
  namespace_id             = snapcd_namespace.sample.id
  source_revision          = "main"
  source_url               = "https://github.com/snapcd-samples/mock-module-storage-account.git"
  source_subdirectory      = ""
  runner_id                = data.snapcd_runner.sample_full.id
  auto_upgrade_enabled     = true
  auto_reconfigure_enabled = true
  auto_migrate_enabled     = false
  clean_init_enabled       = false
}

resource "snapcd_module_input_from_literal" "storage_params_string" {
  for_each = {
    storage_account_name = "demostorage"
    replication_type     = "LRS"
    tier                 = "Standard"
    location             = "East US"
  }
  input_kind    = "Param"
  module_id     = snapcd_module.storage.id
  name          = each.key
  literal_value = each.value
  type          = "String"
}