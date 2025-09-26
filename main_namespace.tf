resource "snapcd_namespace" "mock" {
  name     = "mock"
  stack_id = data.snapcd_stack.sample_full.id
}