# Neptune Tests

Neptune Tests is a real-world integration test repository for [Neptune](https://github.com/devopsfactory-io/neptune) — a Terraform/OpenTofu PR automation tool. It serves as both a reference example of a realistic IaC project and the CI integration target for Neptune's test pipeline.

**Language**: HCL (Terragrunt + OpenTofu). No Go code — this is a pure IaC fixture repository.

---

## Mandatory Rules

These rules always apply — do not skip them under any circumstances.

### DCO Sign-off

Every commit **must** be signed off with `git commit -s`. The DCO bot is enabled; PRs with unsigned commits will fail.

- If you committed without sign-off: `git commit --amend -s --no-edit` then force-push.
- Never add `Made-with: Cursor` or similar trailers to commit messages.

Before every commit, verify `user.name` and `user.email` are set in git config (global or local):

```sh
git config user.name   # must return a non-empty value
git config user.email  # must return a non-empty value
```

If either is missing, resolve the values before committing:

1. Try to infer them from context — run `gh api user --jq '.name,.email'` to retrieve the authenticated GitHub user's name and email.
2. If the email is private or empty, try `gh api user/emails --jq '.[].email'` and pick the primary address.
3. If the values still cannot be determined, **ask the user** what `user.name` and `user.email` should be — do not use placeholder values.

Once resolved:

```sh
git config user.name "<resolved name>"
git config user.email "<resolved email>"
```

### Documentation After Changes

After any change that affects behavior, config, CI, or stack structure, delegate documentation updates to the **documentation-maintainer** agent.

**Within a Claude Code session:** Use the Agent tool with `subagent_type: "documentation-maintainer"` and describe what changed in the prompt.

**From terminal:**

```bash
claude --agent documentation-maintainer "update docs for: <what changed>"
```

---

## IaC Standards

Applies to all `**/*.tf`, `**/*.hcl` files:

- **Tool preference**: Always use OpenTofu (`tofu` CLI) over Terraform. Fall back to `terraform` only if `tofu` is not available.
- **Format**: Run `tofu fmt -recursive` before committing.
- **Validate**: Run `tofu validate` in stack directories before committing.
- **Modules**: All stacks source from `_modules/` via Terragrunt. New stacks should follow the same pattern.
- **Stack discovery**: Neptune uses `stack.hcl` files for local stack management. Each stack directory must have a `stack.hcl` with `name` and `depends_on`.
- **Variables**: Use `variables.tf` for inputs, `outputs.tf` for outputs, `main.tf` for resources.
- **No real cloud resources**: This is a test repository. All stacks use `null_resource` and `local_file` providers only.
- **Backend**: S3 for Terraform state (`tf-neptune-tests-backend`). Do not change backend configuration without approval.

---

## Stack Architecture

10 stacks organized in tiers with dependency chains:

```
Level 0: foundation/org
Level 1: foundation/iam, foundation/network
Level 2: foundation/dns, platform/compute, platform/storage
Level 3: platform/monitoring, apps/api, apps/worker
Level 4: apps/web
```

Dependencies are declared in `stack.hcl` via `depends_on`. The dependency chain matters for Neptune's plan/apply ordering.

---

## Neptune Configuration

See `.neptune.yaml` for the full config. Key settings:

- `stacks_management: local` — Neptune discovers stacks via `stack.hcl` files
- `automerge: true` — PRs auto-merge after successful apply
- Workflow steps use `terragrunt init/plan/apply` with `TERRAGRUNT_TFPATH=tofu`

---

## CI

Applies to `.github/workflows/neptune.yml`:

- **Trigger**: `repository_dispatch` from Neptune GitHub App (neptbot)
- **Dual-mode**: Downloads released Neptune binary normally; builds from source when PR description contains `neptune-ref: <SHA>` (used by Neptune CI tests)
- **Runner**: Self-hosted (`[self-hosted, medium]`)
- **Tools**: OpenTofu 1.9.0, Terragrunt 0.75.0, AWS credentials via OIDC

Do not modify the workflow without understanding the Neptune CI testing flow. Changes here affect Neptune's own CI pipeline.

---

## Agents, Commands, and Skills

Available in `.claude/`:

| Type | Name | Purpose |
| ---- | ---- | ------- |
| Agent | `em` | Engineering Manager — coordinates neptune-tests agents |
| Agent | `iac-developer` | Implements Terragrunt/OpenTofu stacks and modules |
| Agent | `qa` | Reviews IaC quality, stack configuration, and correctness |
| Agent | `security` | Scans HCL, workflows, and config for vulnerabilities |
| Agent | `platform-engineering` | Manages CI/CD workflows and operational config |
| Agent | `documentation-maintainer` | Keeps documentation in sync with code and config |
| Agent | `pr-reviewer` | Reviews PRs for IaC quality, DCO, and docs |
| Agent | `issue-reviewer` | Triages open issues; validates drafts before upload |
| Agent | `issue-writer` | Creates GitHub issues from `/feature` and `/bug` |
| Command | `/bug` | Create a bug report (invokes issue-writer) |
| Command | `/feature` | Create a feature request (invokes issue-writer) |
| Skill | `maintain-documentation` | Delegates doc updates to documentation-maintainer agent |
| Skill | `open-pull-request` | Commits and opens a PR via `gh` with DCO sign-off |
| Skill | `testing-and-ci` | Explains CI workflows and validates IaC |
