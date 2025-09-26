resource "snapcd_module" "vpc" {
  name                     = "vpc"
  namespace_id             = snapcd_namespace.mock.id
  source_revision          = "main"
  source_url               = "https://github.com/snapcd-samples/mock-module-vpc.git"
  source_subdirectory      = ""
  runner_id                = data.snapcd_runner.sample_full.id
  auto_upgrade_enabled     = true
  auto_reconfigure_enabled = true
  auto_migrate_enabled     = false
  clean_init_enabled       = false
  init_before_hook         = "echo $SOME_ENV_VAR"
}

resource "snapcd_module_input_from_literal" "vpc_params" {
  for_each = {
    vpc_name            = "demo-vpc"
    vpc_cidr_block      = "10.0.0.0/16"
    public_subnet_cidr  = "10.0.1.0/24"
    private_subnet_cidr = "10.0.2.0/24"
  }
  input_kind    = "Param"
  module_id     = snapcd_module.vpc.id
  name          = each.key
  literal_value = each.value
  type          = "String"
}

resource "snapcd_module_input_from_literal" "env_vars" {
  for_each = {
    SOME_ENV_VAR = "Hello World!"
  }
  input_kind    = "EnvVar"
  module_id     = snapcd_module.vpc.id
  name          = each.key
  literal_value = each.value
  type          = "String"
}
