data "snapcd_stack" "sample_full" {
  name = var.stack_name
}

data "snapcd_runner" "sample_full" {
  name = var.runner_name
}

data "snapcd_stack_secret" "storefront_db_user_password" {
  name     = var.sample_stack_secret_1_name 
  stack_id = data.snapcd_stack.sample_full.id
}

data "snapcd_stack_secret" "storefront_api_key" {
  name     = var.sample_stack_secret_2_name 
  stack_id = data.snapcd_stack.sample_full.id
}

