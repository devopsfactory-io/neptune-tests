---
name: maintain-documentation
description: Ensures human and AI documentation stay in sync with code and config. Use when changing stacks, Neptune config, CI, or when the user asks to update docs. Delegates the actual updates to the documentation-maintainer subagent.
---

# Maintain Documentation

## When to Use

Use this skill when:
- Adding or modifying stacks or modules
- Changing Neptune configuration (`.neptune.yaml`)
- Modifying CI workflows
- Changing project structure or conventions
- The user asks to update or review documentation

## What to Do

**Delegate documentation updates to the documentation-maintainer subagent** (managed in the hub at `.claude/agents/neptune-tests/documentation-maintainer/`).

When this skill applies, invoke the **documentation-maintainer** subagent with a prompt that describes what changed so it can run its full checklist and update README, CLAUDE.md, and .claude/skills as needed.
