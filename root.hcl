remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "tf-neptune-tests-backend"
    key    = "${path_relative_to_include()}/terraform.tfstate"
    region = "us-east-1"

    # Skip Terragrunt bucket property checks during init. The bucket is already
    # configured with proper security settings. Without these flags, Terragrunt
    # prompts to update bucket properties which fails with EOF in CI.
    skip_bucket_versioning             = true
    skip_bucket_ssencryption           = true
    skip_bucket_root_access            = true
    skip_bucket_enforced_tls           = true
    skip_bucket_public_access_blocking = true
    skip_bucket_accesslogging          = true
  }
}
