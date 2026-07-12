# Decisions

Cross-feature architecture and technology decisions. One entry per decision, newest first.

Format:
```
## <YYYY-MM-DD> <decision title>
- Decision: <what was chosen>
- Because: <constraint or reason>
- Instead of: <rejected alternative, one line>
- Scope: <where this binds — module, stack, whole project>
- Source: features/<feature>
```

Rules: entries are append-only; a reversed decision gets a NEW entry linking the old one, the old entry is never edited. Only decisions that bind FUTURE work belong here — one-off choices stay in `.project/<feature>/decisions.md`.

---

## 2026-07-11 P6 revived: module frontmatter + INDEX + context-pack (supersedes "P6 dropped")
- Decision: all 22 modules carry frontmatter (name, description); modules/INDEX.md routes by situation; context-pack.sh emits deterministic tier-1 pack per task
- Because: module count grew, token cost became a stated priority (Retrieval Engine analysis), and "When to Load" inside the body forces reading the body to decide whether to read it
- Instead of: full retrieval engine (embeddings/vector index) — agentic search won for code in 2026; only the deterministic slice is precomputed
- Scope: .ai/modules/*, .ai/scripts/context-pack.sh
- Source: user directive, 2026-07-11

## 2026-07-11 Playbooks removed entirely (supersedes "Playbooks are SKILL.md-compatible")
- Decision: .ai/playbooks/ deleted. Stack conventions now come from: existing project code (canonical) → .ai/knowledge/conventions.md (learned) → Agent Skills installed in the host tool (ecosystem expertise)
- Because: user call — the Agent Skills ecosystem already ships maintained stack expertise (Stripe, framework, DB skills from vendors); duplicating it in-kit is maintenance burden; project code + learned conventions cover what's project-specific
- Instead of: maintaining 14 in-kit playbooks
- Scope: whole kit (all agents, modules, commands, pointer files updated)
- Source: user directive, 2026-07-11

## 2026-07-11 Multi-agent coordination: claim-by-commit, orchestrator = Planner
- Decision: parallel agents coordinate in two modes — tool-native (Agent Teams etc.) or repo-native claim-by-commit on tasks.md (push rejected = task taken); one worktree + `agent/<feature>-<task-id>` branch per task; Planner doubles as orchestrator (no 11th agent), never writes feature code while orchestrating; 3 safety checks (files disjoint, interface stable, no needs:) gate parallelization
- Because: kit is markdown-only — git itself must be the lock; orchestrator with clean context is the 2026 consensus pattern
- Instead of: lock files, a dedicated orchestrator agent, or tool-specific-only coordination
- Scope: whole project (git.md, planner.md, task-breakdown.md)
- Source: upgrade-2026 P5

## 2026-07-11 Playbooks are SKILL.md-compatible; repo is canonical for skills
- Decision: all playbooks carry Agent Skills frontmatter (name, description); export = copy as `<name>/SKILL.md` into a tool's skills dir; repo remains the canonical source, tool dirs are projections
- Because: Agent Skills is the AAIF open standard read by 32+ tools; repo-canonical keeps team + agents on one version
- Instead of: maintaining separate skill copies per tool
- Scope: .ai/playbooks/*
- Source: upgrade-2026 P2

## 2026-07-11 P6 (module INDEX / progressive disclosure) dropped
- Decision: no modules/INDEX.md, no module frontmatter — P6 cancelled by user
- Because: user call; AGENTS.md directory map + module "When to Load" sections cover routing adequately at current kit size (20 modules)
- Instead of: 20 frontmatter edits + INDEX table
- Scope: .ai/modules/
- Source: upgrade-2026 close-out

## 2026-07-11 Four-tier split: features/ (intent) vs .project/ (execution)
- Decision: features/ holds requirements+research (user + Researcher write only); .project/ holds plan/tasks/architecture/decisions/progress (agents write); tasks.md replaces todo.md; lifecycle via .project/INDEX.md metadata, not folder moves (except archive/)
- Because: separating intent from execution makes plans regenerable (change stack → delete .project/<x>, regenerate from features/<x>) and prevents feature folders becoming graveyards
- Instead of: original mixed layout (brief + todo + context in one folder); physical backlog/active/done folder moves (breaks paths/history)
- Scope: whole project
- Source: features/upgrade-2026 (P4.5)

## 2026-07-11 Canonical instruction entry point
- Decision: AGENTS.md is the single canonical rules file; tool files (CLAUDE.md, .cursor/rules, ...) are thin pointers
- Because: 28+ tools read AGENTS.md natively; duplicated rules drift
- Instead of: maintaining parallel per-tool rule files
- Scope: whole project
- Source: features/upgrade-2026
