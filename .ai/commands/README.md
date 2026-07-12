# Commands

Canonical command prompts — tool-agnostic. Each file is a complete instruction an agent executes when the user invokes the command. Edit HERE only; tool directories hold thin pointers.

| Command | Does |
|---|---|
| `plan` | brief → `.project/<x>/plan.md` + `tasks.md` (planning pipeline, G1) |
| `implement` | pick next claimable task → execute per owner contract → close with G2 |
| `review` | run review module on the feature's diff (G3) |
| `status` | report INDEX + tasks progress + what's next |

## Per-Tool Wiring

- **Claude Code**: `.claude/commands/<name>.md` (ships with kit) → `/plan`, `/implement`, ...
- **Windsurf**: `.windsurf/workflows/<name>.md` (ships with kit) → `/plan`, ...
- **Codex CLI**: copy files into `~/.codex/prompts/` (global, per-machine)
- **Gemini CLI**: convert to custom command TOML per its docs
- **Cursor / others without custom commands**: paste the canonical file content as the prompt — it is self-contained

Pointer format keeps projections drift-free: they only say "follow `.ai/commands/<name>.md` with these arguments".
