---
name: open-pull-request
description: Commits current changes and opens a pull request via GitHub CLI (gh). Use only when the user explicitly says "open a pull request" or "create a pull request". Do not run this workflow for other requests.
---

# Open a Pull Request

## When to Use

Use this skill **only** when the user explicitly requests to open a pull request. Do not run git commit, push, or `gh pr create` for any other request.

## Preconditions

1. **Working tree**: Confirm that current changes are what the user wants to commit. If unclear, ask.
2. **GitHub CLI**: Require `gh` installed and authenticated. Run `gh auth status`; if not OK, stop.

## Workflow

### 1. Create a new branch

- `git checkout -b <branch-name>`
- **Branch name**: Use `feat/...`, `fix/...`, `ci/...` patterns. Prefer lowercase, hyphens; avoid spaces.

### 2. Stage and commit

- Run `git add .`
- **Commit message**: Use conventional style (e.g. `feat: add new test stack`, `fix: correct dependency chain`).
- Run `git commit -s -m "<message>"` — DCO sign-off required.

### 3. Push and create PR

- Push: `git push -u origin <branch-name>`
- Create PR: `gh pr create --title "<title>" --body "<body>"`

### 4. PR body

Populate:
- **What changed** — Short description of the changes.
- **Why** — Motivation or context.
- **Testing** — How the changes were validated (e.g. `tofu validate`, manual review).
- **Related issues** — e.g. `Fixes #123` if applicable.

### 5. Safety

- Do not run `git push`, `git commit`, or `gh pr create` unless the user has explicitly requested to open a pull request.
- If the repo is in an unexpected state, ask before proceeding.
