# neptune-tests

Real-world integration test repository for [Neptune](https://github.com/devopsfactory-io/neptune) — a Terraform/OpenTofu PR automation tool.

## Purpose

This repository serves two roles:

1. **Reference example** — A realistic IaC project using Terragrunt + OpenTofu with Neptune for PR automation, including dependency chains and a 3-tier stack hierarchy.
2. **CI integration target** — Neptune's CI pipeline creates test PRs here to validate plan/apply against real stacks before releasing.

## Stack Architecture

10 stacks organized in 3 tiers with `depends_on` relationships:

```
Level 0: foundation/org
Level 1: foundation/iam, foundation/network
Level 2: foundation/dns, platform/compute, platform/storage
Level 3: platform/monitoring, apps/api, apps/worker
Level 4: apps/web
```

All stacks use `null_resource` and `local_file` providers — no real cloud infrastructure is provisioned.

### Stack Management

- **Discovery:** `stacks_management: local` with `stack.hcl` files in each stack directory
- **Dependencies:** Declared via `depends_on` in `stack.hcl`
- **Modules:** All stacks source `_modules/null-stack/` via Terragrunt
- **Backend:** S3 for Terraform state (`tf-neptune-tests-backend`)
- **Locking:** S3 for Neptune stack locks (`neptune-tests-locks`)

## Neptune Configuration

See [`.neptune.yaml`](.neptune.yaml) for the full config. Key settings:

- `stacks_management: local` — Neptune discovers stacks via `stack.hcl` files
- `automerge: true` — PRs auto-merge after successful apply
- Workflow steps use `terragrunt init/plan/apply` with `TG_TF_PATH=tofu`

## CI Testing (Neptune PR Builds)

When a PR is opened on the Neptune repository, the CI creates a test PR here with dynamic stacks under `apps/web/ci-<pr-id>-*/`. The `neptune.yml` workflow detects a `neptune-ref:` marker in the PR description and builds Neptune from source at that commit instead of downloading a release.

This tests the full webhook flow: PR creation -> neptbot webhook -> Lambda dispatch -> plan/apply.

## Tools

- [OpenTofu](https://opentofu.org/) 1.9.0
- [Terragrunt](https://terragrunt.gruntwork.io/) 0.75.0
- [Neptune](https://github.com/devopsfactory-io/neptune) for PR automation
