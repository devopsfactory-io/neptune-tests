# Create a bug report

Use the **issue-writer** subagent (managed in the hub at `.claude/agents/neptune-tests/issue-writer/`) to open a GitHub bug report for this repo.

The user's message after `/bug` is the initial description. Follow the issue-writer workflow: use title format "Area: Short description", gather What happened?, What did you expect?, Did this work before?, How do we reproduce?, and optional environment/versions, ask for more details if needed. Before creating the issue, validate the draft with the **issue-reviewer** subagent; only then run `gh issue create`.
