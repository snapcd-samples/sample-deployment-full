resource "snapcd_namespace" "sample" {
  name     = "sample-full"
  stack_id = data.snapcd_stack.sample_full.id
}