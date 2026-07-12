# Changelog

## v0.3.0 — 2026-07-11
- Playbooks removed entirely: stack conventions now come from existing project code + .ai/knowledge/conventions.md + Agent Skills installed in the host tool (see knowledge/decisions.md)

## v0.2.0 — 2026-07-11
- Command layer: canonical prompts .ai/commands/ (plan, implement, review, status) + projections for Claude Code (.claude/commands) and Windsurf (.windsurf/workflows)
- Repo-level automation (tool-agnostic): next-task.sh (dependency-aware task picker), check-gates.sh (G4 mechanical checks), .githooks/pre-commit, CI workflow gates.yml; task IDs (T<n>) in tasks.md schema
- Multi-agent coordination: worktree conventions, claim-by-commit, orchestrator duties (Planner), 3 parallelization safety checks
- Four-tier architecture: features/ (intent, user+Researcher only) split from new .project/ (execution: plan, tasks, architecture, decisions, progress)
- tasks.md replaces todo.md; .project/INDEX.md tracks feature lifecycle (backlog/active/done/archived)
- Write-permission matrix per agent in AGENTS.md
- Enforcement gates G1–G5 (.ai/modules/gates.md) with Claude Code hooks / CI mapping
- Agent Skills (SKILL.md) frontmatter on all 14 playbooks
- Scale-adaptive sizing gate (trivial/standard/large) with fast path
- Cross-feature memory: .ai/knowledge/ (decisions, conventions, postmortems)
- .workspace/ ephemeral tier (gitignored) with session resume
- Multi-tool compatibility: AGENTS.md canonical + pointers (CLAUDE.md, .cursor, .github, .windsurf, GEMINI.md)
- Full content for 10 agents, 19 modules, 15 playbooks, 5 templates

## v0.1.0
- Initial Core release
