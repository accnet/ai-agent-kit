# Claude Code — AI-Kit

Read `AGENTS.md` at the repo root and follow it exactly. It is the canonical runtime entry point for this project.

Do not duplicate rules here. Claude-specific notes only:

- Use your TodoWrite/task tools to mirror `.project/<feature>/tasks.md`, but tasks.md remains the source of truth
- Subagents map to `.ai/agents/` roles: pass the relevant agent file as the subagent's contract
- Plan Mode aligns with the planning_first rule — plan before exiting to implementation
