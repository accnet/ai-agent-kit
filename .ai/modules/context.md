# Module: Context

## Purpose
Load the minimum context needed for the current task — no more (rules.yaml: minimal_context).

## When to Load
Always, immediately after planning. Context is assembled per task, not per feature.

## Submodules
Pipeline order:

1. `context/context-loader.md` — gather candidate sources
2. `context/dependency-analysis.md` — expand to affected code (when modifying existing code)
3. `context/context-ranking.md` — rank candidates by relevance
4. `context/token-budget.md` — cut to budget
5. `context/context-assembler.md` — merge into working context
6. `context/knowledge-loader.md` — add business/architecture rules (when task touches domain logic)

Trivial task (single known file) → loader + budget is enough.

## Rules
- Check `.workspace/session.md` first when resuming — it may already point at the exact context needed
- Loading "just in case" is a violation — every loaded item must serve the current task
- Context is rebuilt when switching tasks, not accumulated
- If needed context doesn't exist (no docs, no brief) → say so; don't fabricate

## Output
A working context set: files, contracts, and rules relevant to the current task.
