# Create a feature request

Use the **issue-writer** subagent (`.claude/agents/issue-writer.md`) to open a GitHub feature request for this repo.

The user's message after `/feature` is the initial idea or title. Follow the issue-writer workflow: gather Why / What / Who details, ask for more info if the description is too short. Before creating the issue, validate the draft with the **issue-reviewer** subagent; only then run `gh issue create`.
