resource "snapcd_module" "app_worker" {
  name                     = "app-worker"
  namespace_id             = snapcd_namespace.mock.id
  source_revision          = "main"
  source_url               = "https://github.com/snapcd-samples/mock-module-kubernetes-app-worker.git"
  source_subdirectory      = ""
  runner_id                = data.snapcd_runner.sample_full.id
  auto_upgrade_enabled     = true
  auto_reconfigure_enabled = true
  auto_migrate_enabled     = false
  clean_init_enabled       = false
}

resource "snapcd_module_input_from_literal" "worker_params_notstring" {
  for_each = {
    replicas = 2
  }
  input_kind    = "Param"
  module_id     = snapcd_module.app_worker.id
  name          = each.key
  literal_value = each.value
  type          = "NotString"
}

resource "snapcd_module_input_from_output_set" "worker_cluster_dependencies" {
  input_kind       = "Param"
  module_id        = snapcd_module.app_worker.id
  name             = "from_cluster"
  output_module_id = snapcd_module.cluster.id
}

resource "snapcd_module_input_from_output_set" "storage_dependencies" {
  input_kind       = "Param"
  module_id        = snapcd_module.app_worker.id
  name             = "from_storage"
  output_module_id = snapcd_module.storage.id
}