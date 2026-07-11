# AI-Kit Core v0.2.0

Chat-first AI runtime foundation. Drop `.ai/` + `AGENTS.md` into any project to give AI coding agents a consistent process: plan first, minimal context, mandatory review — enforced by gates.

## Entry Point

`AGENTS.md` is the single canonical instruction file. All tool-specific files are thin pointers to it — edit rules in AGENTS.md only.

## Four-Tier Architecture

| Tier | Role | Committed |
|---|---|---|
| `.ai/` | durable knowledge & process | yes |
| `features/` | requirements & research (intent — user + Researcher only) | yes |
| `.project/` | execution: plan, tasks, architecture, progress | yes |
| `.workspace/` | ephemeral session state | no |

Key property: `.project/<x>/` is always **regenerable** from `features/<x>/`. Change stacks, throw away the plan, regenerate — requirements survive.

## Tool Compatibility

| Tool | Reads | Mechanism |
|---|---|---|
| OpenAI Codex | `AGENTS.md` | native |
| Devin | `AGENTS.md` | native |
| Cursor | `AGENTS.md` + `.cursor/rules/ai-kit.mdc` | native + always-on rule |
| GitHub Copilot | `AGENTS.md` + `.github/copilot-instructions.md` | native + repo instructions |
| Windsurf | `AGENTS.md` + `.windsurf/rules/ai-kit.md` | native + always-on rule |
| Claude Code | `CLAUDE.md` → AGENTS.md | pointer |
| Gemini CLI | `GEMINI.md` → AGENTS.md | pointer |

## Structure

```
AGENTS.md          canonical entry point
.ai/agents/        10 role contracts with write permissions
.ai/modules/       process standards (planning, context, gates, review, ...)
.ai/knowledge/     cross-feature memory (decisions, conventions, postmortems)
.ai/templates/     brief / plan / tasks / progress templates
features/<x>/      brief.md + research/ + context/   ← intent
.project/<x>/      plan, tasks, architecture, decisions, progress ← execution
.project/INDEX.md  feature lifecycle: backlog / active / done / archived
.workspace/        session state — gitignored, safe to delete
```

## Stack Conventions

The kit ships no per-stack playbooks. Convention sources, in order: existing project code (canonical) → `.ai/knowledge/conventions.md` (learned, project-specific) → [Agent Skills](https://agentskills.io) installed in the host tool for stack expertise (Stripe, Postgres, framework skills from the ecosystem).

## Repo-Level Automation (tool-agnostic)

Works for every IDE/agent, because it lives in the repo, not the tool:

- `.ai/scripts/next-task.sh <feature>` — prints claimable tasks (unchecked, unclaimed, dependencies resolved). Any agent's entry point for picking work.
- `.ai/scripts/check-gates.sh staged|all` — mechanical Gate G4: no `.workspace/` leaks, no secrets.
- `.githooks/pre-commit` — runs G4 on every commit. Activate once per clone: `git config core.hooksPath .githooks`
- `.github/workflows/gates.yml` — CI enforcement: G4 on all files + G2 (runs `test_command` from `.ai/ai.yaml`; set it in your host project).

Tool-native hooks/subagents/commands are optional accelerators on top — see `.ai/modules/gates.md`.

## Commands

Canonical prompts in `.ai/commands/` (plan, implement, review, status) — self-contained, tool-agnostic. Shipped projections: `.claude/commands/` (Claude Code `/plan` ...) and `.windsurf/workflows/`. Codex/Gemini: copy per `.ai/commands/README.md`. Other tools: paste the canonical file as the prompt.

## Rules

1. Planning first — no code before `.project/<x>/tasks.md` with acceptance criteria (G1)
2. Minimal context — load only what the current task needs
3. Review required — nothing completes without passing review (G3)
4. Only user + Researcher write to `features/`; execution artifacts live in `.project/`
# ai-agent-kit
