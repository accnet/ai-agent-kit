# Module Index

Route from this table — read a module's body only when this index says it applies. Every module carries matching frontmatter (name, description).

## Always Loaded
| Module | Why |
|---|---|
| gates.md | G1–G5, retry policy, execution log — every agent, every task |
| planning/intent-analysis.md | classify + size + Intake — first thing, every request |

## Per Phase
| Situation | Load |
|---|---|
| Session start / resume / end | workspace.md |
| Planning a feature/refactor | planning.md → task-breakdown.md → acceptance.md → planning/planning.md |
| Starting any task (building context) | context.md → context-loader.md → [dependency-analysis.md if modifying existing code] → context-ranking.md → token-budget.md → context-assembler.md |
| Task touches domain logic / money / permissions | context/knowledge-loader.md |
| Before any commit | git.md |
| Agents running in parallel | git.md (Worktrees & Parallel Agents) |
| Review / self-review before handoff | review.md |

## Per Intent / Owner
| Situation | Load |
|---|---|
| Intent = bug | debugging.md |
| Intent = refactor | refactoring.md |
| Task owner = backend | backend.md |
| Task owner = frontend | frontend.md |
| Task touches schema / owner = database | database.md |
| Writing tests (any task) | testing.md |

Shortcut: `.ai/scripts/context-pack.sh <feature> T<n>` emits the deterministic tier-1 context pack for a task (task line, criteria, files: contents, brief, knowledge hits) — start there, then load modules per this table.
