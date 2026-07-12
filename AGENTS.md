# AI-Kit Core

Chat-first AI runtime for coding agents. This file is the **canonical entry point** — every AI tool (Claude Code, Codex, Copilot, Cursor, Windsurf, Devin, ...) starts here. Tool-specific files (CLAUDE.md, .cursor/rules, .github/copilot-instructions.md) only point back to this file; never duplicate rules into them.

## Four-Tier Model

| Tier | Role | Written by | Committed |
|---|---|---|---|
| `.ai/` | durable knowledge & process | maintainers | yes |
| `features/` | requirements & research — WHAT the user wants | user + Researcher only | yes |
| `.project/` | execution — HOW it gets built (plan, tasks, architecture, progress) | agents | yes |
| `.workspace/` | ephemeral session state | agents | **no** (gitignored) |

`features/` is the single source of truth for intent. `.project/<feature>/` is always regenerable from `features/<feature>/` — deleting it loses no requirements. Agents other than Researcher never write to `features/`.

## Startup Procedure

0. Check `.workspace/session.md` — if present and current, resume from its `next:` step
1. Read `.ai/ai.yaml`, `.ai/models.yaml`, `.ai/rules.yaml`
2. Check `.project/INDEX.md` for feature states (backlog / active / done / archived)
3. Detect intent and size → `.ai/modules/planning/intent-analysis.md`
4. Select your agent role from `.ai/agents/` and follow its contract (Responsibilities, Decision Rules, Escalation, Done Criteria)
5. Load required modules from `.ai/modules/` — only what the task needs
6. Load stack conventions: existing project code patterns (canonical) + `.ai/knowledge/conventions.md`
7. Read `features/<feature>/` (brief, research/, context/) — read-only
8. Read project source (per `.ai/modules/context.md` pipeline)
9. Plan → write `.project/<feature>/plan.md` + `tasks.md` (mandatory before any code — Gate G1)
10. Execute task by task — pick work via `.ai/scripts/next-task.sh <feature>`; a task closes only when its acceptance criteria pass (Gate G2); keep `tasks.md` as the single source of execution state
11. Review per `.ai/modules/review.md` before marking anything complete (Gate G3)
12. Update `.project/<feature>/` (tasks, progress, decisions) and `.project/INDEX.md` when done
13. Maintain `.workspace/session.md` on every task switch; graduate anything worth keeping out of `.workspace/` before ending the session

## Directory Map

```
.ai/agents/     10 agent roles: planner, architect, backend, frontend,
                database, reviewer, qa, documenter, release, researcher
.ai/modules/    process standards: planning/*, context/*, gates, backend,
                frontend, database, testing, review, git, workspace
.ai/knowledge/  cross-feature memory: decisions, conventions, postmortems
.ai/templates/  brief, plan, tasks, progress, context-checklist
features/<x>/   INPUT: brief.md + research/ + context/ — user + Researcher only
.project/<x>/   EXECUTION: plan.md, tasks.md, architecture.md,
                decisions.md, progress.md; INDEX.md tracks feature states
.workspace/     session.md + scratch/ + drafts/ — local only, never committed
```

## Write Permissions

| Agent | Writes |
|---|---|
| Researcher | `features/<x>/research/` |
| Planner | `.project/<x>/plan.md`, `tasks.md` |
| Architect | `.project/<x>/architecture.md`, `decisions.md` |
| Backend / Frontend / Database | code + tests; task status in `tasks.md` |
| QA | tests; defects into `tasks.md` |
| Reviewer | verdict + findings into `tasks.md`, `decisions.md` |
| Documenter | docs, `progress.md`, graduation to `.ai/knowledge/` |
| Release | CHANGELOG, release notes, `.project/INDEX.md` state |

No agent writes to `features/` except Researcher. No agent edits `.ai/` except on explicit user request.

## Hard Rules (rules.yaml) — enforced by `.ai/modules/gates.md`

- **planning_first** — no implementation before `.project/<x>/tasks.md` exists with acceptance criteria (Gate G1)
- **minimal_context** — load only what the current task needs; rebuild context per task
- **review_required** — nothing is complete until it passes `.ai/modules/review.md` (Gate G3)
- **db_changes_require_plan** — any request that modifies the database (schema OR data: migrations, DDL, bulk/data updates, seeds) is never trivial and never uses the fast path; a `.project/<x>/tasks.md` (or a `features/<x>/`) must exist first (Gate G1)

Gates G2 (task-complete), G4 (commit hygiene), and G5 (destructive ops need user approval) apply to every agent. Gates cannot be waived by an agent — only by the user, explicitly, per instance.

## Additional Constraints

- Existing project code is the canonical convention source; follow its patterns, report drift instead of refactoring uninvited. Stack-specific knowledge may also come from Agent Skills installed in the host tool
- Destructive operations (dropping data, force-push shared branches, production deploys) require explicit user approval
- Every task's "done" is its acceptance criterion in `tasks.md` — not the agent's opinion
- `.workspace/` is never committed and never referenced from committed files
- `.project/<x>/` must stay regenerable: requirements discovered mid-work go to `features/<x>/` (via user or Researcher), never buried in tasks

## Definition of Done (any task)

Acceptance criteria met → tests pass → review verdict approve → `tasks.md` + `INDEX.md` updated.
