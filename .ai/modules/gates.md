---
name: gates
description: Enforcement gates G1–G5, retry policy, execution log. Load always — applies to every agent and task.
---

# Module: Gates

## Purpose
Turn the kit's rules from honor-system into enforced checkpoints. Every gate defines: trigger, check, and failure action. A failed gate blocks progress — it is never advisory.

## When to Load
Always. Gates apply to every agent and every task.

## Gate Definitions

### G1 — Plan Gate (enforces planning_first)
- **Trigger**: before the first code/file change of a feature
- **Check**: `.project/<feature>/tasks.md` exists, has ≥1 task with acceptance criteria, no unresolved blocker questions. Trivial-sized work (per intent-analysis Sizing Gate) satisfies G1 with the inline fast-path checklist instead — **except any database change (schema OR data), which is never trivial and always requires a full `tasks.md` or a `features/<feature>/` (rules.yaml: `db_changes_require_plan`)**
- **Failure action**: stop; run the planning module; do not touch code

### G2 — Task-Complete Gate (enforces acceptance criteria)
- **Trigger**: agent wants to mark a tasks.md task `[x]`
- **Check**: task's acceptance criteria demonstrably met; tests relevant to the task pass; lint/typecheck clean on changed files
- **Failure action**: task stays `[ ]`; failure noted under the task; fix before proceeding

### G3 — Review Gate (enforces review_required)
- **Trigger**: all implementation tasks of a feature checked
- **Check**: review verdict exists per `.ai/modules/review.md` with zero blockers; every checklist item of the owning agent's contract confirmed
- **Failure action**: feature stays open; findings become tasks in tasks.md

### G4 — Commit Gate (enforces hygiene)
- **Trigger**: before any commit
- **Check**: no `.workspace/` paths referenced in committed files; no secrets/credentials; diff maps to a tasks.md task; tests pass
- **Failure action**: commit aborted; violation reported

### G5 — Destructive-Op Gate (enforces user approval)
- **Trigger**: dropping data, irreversible migration, force-push shared branch, production deploy
- **Check**: explicit user approval recorded in the conversation for THIS specific operation
- **Failure action**: operation not executed; ask the user

## Enforcement Mapping

| Gate | Repo-level (ships with kit, all tools) | Tool-native (optional adapters) |
|---|---|---|
| G1 | convention: agent self-check at step 9 of AGENTS.md | Claude Code hook: PreToolUse on Edit/Write → check tasks.md exists |
| G2 | CI: `.github/workflows/gates.yml` runs `test_command` from ai.yaml on every PR | hook: PostToolUse/Stop → run tests locally (earlier feedback) |
| G3 | required PR review / status check | subagent: reviewer role before completion |
| G4 | `.githooks/pre-commit` → `.ai/scripts/check-gates.sh` (workspace leaks + secrets); same script in CI (`all` mode) | hook: PreToolUse on Bash(git commit) |
| G5 | branch/environment protection rules | permission deny-list for destructive commands |

Activation (once per clone): `git config core.hooksPath .githooks`

Notes:
- Repo-level enforcement is canonical — it works regardless of which IDE/agent produced the code. Tool-native hooks only move the same checks earlier in the loop.
- `.ai/scripts/next-task.sh <feature>` gives any agent the claimable tasks (deps resolved) — the mechanical half of task orchestration.
- Where no mechanical enforcement exists, the gate still applies as a mandatory self-check — an agent that skips it is in violation of AGENTS.md

## Retry Policy (task fails G2)
Attempts are tracked on the task line: `| attempts: <n>` (rendered by `.ai/scripts/state.sh`). On each G2 failure the owning agent:
1. Notes the failure under the task and logs it: `.ai/scripts/log-event.sh retry <feature> T<n> <instance> "<why it failed>"`.
2. Increments `attempts`, fixes the cause, and re-runs G2 — the task never gets marked `[x]` until G2 passes.
3. After **3** failed attempts, stops and escalates: logs `escalated`, leaves the task `[ ]`, and asks the user for direction. Silent retries are a violation — every attempt stays visible in `tasks.md` and the log.

## Execution Log
`.project/log.jsonl` is the append-only record of gate and task activity, written by `.ai/scripts/log-event.sh` — one JSON object per line: `{ts, event, feature, task, actor, detail}`. Events: `claimed | gate_pass | gate_fail | retry | completed | escalated`. The log is derived history, not state: `tasks.md` remains the source of truth, and `.ai/scripts/state.sh <feature>` renders current task state (including `attempts`) as JSON on demand.

## Rules
- Gates are ordered: G1 before any code, G2 per task, G3 per feature, G4 per commit, G5 whenever triggered
- A gate may not be waived by an agent; only the user can waive, explicitly, per instance
- Gate failures are recorded in tasks.md — silent retries hide systemic problems

## Output
Gate results visible in tasks.md (task notes) and review verdicts; violations always surfaced to the user.
