terraform {
  source = "../../../_modules/null-stack"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  stack_name = "apps/web/ci-123-2"
}