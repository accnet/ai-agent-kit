# Command: plan

Argument: `<feature>` — a directory name under `features/`.

Take the role of **Planner** (`.ai/agents/planner.md`). Produce the execution plan for the feature.

## Steps
1. Read `features/<feature>/brief.md`, `research/`, `context/` (read-only)
   - brief.md missing → run Intake (`intent-analysis.md`): draft the brief from the user's request, read it back, save only on their approval — then continue
2. Run intent analysis + sizing gate (`.ai/modules/planning/intent-analysis.md`)
   - trivial → output the inline fast-path checklist and STOP (no plan.md needed)
3. If design is non-obvious or size is large: escalate to Architect role for `.project/<feature>/architecture.md` first
4. Break down tasks (`.ai/modules/planning/task-breakdown.md`): atomic, T-IDs, owner, scope, needs, files; run the 3 parallelization safety checks
5. Attach acceptance criteria per task (`.ai/modules/planning/acceptance.md`)
6. Write `.project/<feature>/plan.md` (templates/plan.md) and `.project/<feature>/tasks.md` (templates/tasks.md)
7. Add/refresh the feature row in `.project/INDEX.md` (state: active)
8. Report: task count, riskiest task, open questions (blockers first)

## Gate
This command satisfies G1. Do NOT write any implementation code — planning only.
