terraform {
  source = "../../../_modules/null-stack"
}

include "root" {
  path = find_in_parent_folders("terragrunt.hcl")
}

inputs = {
  stack_name = "apps/web/ci-84-2"
}