---
name: testing-and-ci
description: Validates IaC configuration and explains CI workflows. Use when validating stacks, checking formatting, or debugging the Neptune dispatch workflow.
---

# Testing and CI

## IaC Validation Commands

- **tofu fmt -check -recursive** — Verify HCL formatting; fails if any file needs formatting.
- **tofu validate** — Validate Terraform/OpenTofu configuration (run from within each stack directory).
- **terragrunt validate** — Validate Terragrunt configuration.

## Stack Validation

To validate all stacks:

```bash
for dir in foundation/org foundation/iam foundation/network foundation/dns \
           platform/compute platform/storage platform/monitoring \
           apps/api apps/worker apps/web; do
  echo "Validating $dir..."
  (cd "$dir" && terragrunt init -upgrade && tofu validate)
done
```

## CI Workflow

### neptune.yml

- **Trigger:** `repository_dispatch` with type `neptune-command` — sent by the Neptune GitHub App (neptbot)
- **Commands:** `plan`, `apply`, `unlock`
- **Concurrency:** Single group `neptune`, no cancel-in-progress
- **Dual-mode binary:**
  - **Normal (webhook):** Downloads released Neptune binary (`v0.2.0`)
  - **CI testing:** If PR description contains `neptune-ref: <SHA>`, clones Neptune at that SHA and builds from source
- **Tools:** OpenTofu 1.9.0, Terragrunt 0.75.0
- **AWS:** OIDC-based credential assumption via `aws-actions/configure-aws-credentials@v4`
- **Runner:** `[self-hosted, medium]`

### How Neptune CI Testing Works

When a PR is opened on the **Neptune** repository, Neptune's CI creates a test PR here with dynamic stacks under `apps/web/ci-<pr-id>-*/`. The `neptune.yml` workflow detects the `neptune-ref:` marker and builds Neptune from source at that commit instead of downloading a release. This validates the full webhook flow: PR creation → neptbot webhook → Lambda dispatch → plan/apply.

## Adding Test Stacks

When adding new stacks for testing:
1. Create the stack directory with `stack.hcl` (name + depends_on) and `terragrunt.hcl`
2. Source from `_modules/null-stack` via Terragrunt
3. Place in the correct tier based on dependencies
4. Update README.md stack architecture section
