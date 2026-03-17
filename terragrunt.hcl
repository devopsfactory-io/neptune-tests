remote_state {
  backend = "s3"

  # Prevent Terragrunt from prompting to update bucket properties (versioning,
  # encryption, etc.) during init. The bucket is already configured with the
  # required security settings. Without this flag, non-interactive CI fails
  # with EOF when Terragrunt prompts for confirmation.
  disable_bucket_update = true

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "tf-neptune-tests-backend"
    key    = "${path_relative_to_include()}/terraform.tfstate"
    region = "us-east-1"
  }
}
