# Command: implement

Argument: `<feature>` (optionally `<feature> T<n>` to force a specific task).

Execute the next claimable task of the feature.

## Steps
1. Verify G1: `.project/<feature>/tasks.md` exists — if not, STOP and run `plan` first
2. Pick work: run `.ai/scripts/next-task.sh <feature>` (or use the forced T<n> if given and claimable)
3. Claim it: `.ai/scripts/next-task.sh <feature> --claim T<n> --instance <name>` (marks the line + logs the event; commit tasks.md if parallel agents — see git.md Coordination Modes)
4. Assume the task's `owner:` role — read that contract in `.ai/agents/` and its checklist
5. Build context: start from `.ai/scripts/context-pack.sh <feature> T<n>` (deterministic tier 1), then `.ai/modules/context.md` pipeline for the rest; route modules via `.ai/modules/INDEX.md`
6. Implement within the task's `files:` scope; touching outside scope → STOP, report to Planner
7. Close with G2: acceptance criteria demonstrably met, tests written and passing, lint clean
8. Tick the task `[x]` with a one-line result note; update `.workspace/session.md`
9. Commit per `.ai/modules/git.md` (one commit = this task; pre-commit runs G4)

## On G2 Failure — Retry Policy (gates.md)
Increment `| attempts: N` on the task line, log a `retry` event (`.ai/scripts/log-event.sh retry <feature> T<n> <name> "<why>"`). Attempts 1–2: self-fix. Attempt 3: switch strategy (debugging.md / Architect / model switch). Attempt 4: STOP, log `escalated`, hand to user.

## Gate
A task that fails G2 stays `[ ]` with the failure noted. Never tick on hope. On success, log `completed`.
