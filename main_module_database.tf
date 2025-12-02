resource "snapcd_module" "database" {
  name                     = "database"
  namespace_id             = snapcd_namespace.sample.id
  source_revision          = "main"
  source_url               = "https://github.com/snapcd-samples/mock-module-database.git"
  source_subdirectory      = ""
  runner_id                = data.snapcd_runner.sample_full.id
  auto_upgrade_enabled     = true
  auto_reconfigure_enabled = true
  auto_migrate_enabled     = false
  clean_init_enabled       = false
}

resource "snapcd_module_input_from_literal" "database_params" {
  for_each = {
    database_name = "demo-db"
    database_sku  = "db.t3.micro"
  }
  input_kind    = "Param"
  module_id     = snapcd_module.database.id
  name          = each.key
  literal_value = each.value
  type          = "String"
}

resource "snapcd_module_input_from_output" "private_subnet_id" {
  input_kind       = "Param"
  module_id        = snapcd_module.database.id
  name             = "private_subnet_id"
  output_module_id = snapcd_module.vpc.id
  output_name      = "private_subnet_id"
}