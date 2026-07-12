# AI-Kit

> **Chat-first AI runtime for coding agents.** Drop `.ai/` + `AGENTS.md` into any repo and every AI coding tool gets a consistent, gated development process — plan first, minimal context, mandatory review.

<p align="center">
  <strong>One instruction file. Ten agent roles. Five enforcement gates. Zero tool lock-in.</strong>
</p>

---

## Why AI-Kit?

AI coding agents are powerful but unpredictable. They skip planning, load too much context, and mark things "done" prematurely. AI-Kit gives them a **structured runtime** — not a framework, not a dependency, just a set of conventions and checkpoints that keep agents focused and accountable.

| Problem | AI-Kit Solution |
|---|---|
| Agents jump straight to code | **Gate G1** — no implementation before a plan + tasks with acceptance criteria |
| Agents load the entire codebase | **Minimal context** — load only what the current task needs, rebuild per task |
| Agents declare "done" too early | **Gate G3** — nothing completes without passing review |
| Every tool has different config | **Single entry point** — `AGENTS.md` is the canonical instruction file for all tools |
| Requirements get lost in execution | **Four-tier model** — intent (`features/`) is separate from execution (`.project/`), always regenerable |

---

## Quick Start

```bash
# 1. Copy the runtime into your project
cp -r ai-kit/.ai ai-kit/AGENTS.md your-project/
cp ai-kit/.githooks/pre-commit your-project/.githooks/

# 2. Activate git hooks (once per clone)
cd your-project
git config core.hooksPath .githooks

# 3. Configure your stack
# Edit .ai/ai.yaml → set test_command for your project
# Add conventions to .ai/knowledge/conventions.md

# 4. Start coding with any AI tool
# The agent reads AGENTS.md → follows the startup procedure → plans before coding
```

That's it. No install, no package dependency, no CLI to learn.

---

## Architecture

### Four-Tier Model

```
┌─ features/<x>/ ──┐   ← WHAT to build (intent)
│  brief.md         │   Written by: user + Researcher only
│  research/        │   Committed: yes
│  context/         │
└───────────────────┘
        │
        │  regenerable — delete .project/, keep features/
        ▼
┌─ .project/<x>/ ──┐   ← HOW it gets built (execution)
│  plan.md          │   Written by: agents
│  tasks.md         │   Committed: yes
│  architecture.md  │
│  progress.md      │
└───────────────────┘
        │
        │  guided by
        ▼
┌─ .ai/ ───────────┐   ← durable knowledge & process
│  agents/ (10)     │   Written by: maintainers
│  modules/         │   Committed: yes
│  knowledge/       │
│  templates/       │
└───────────────────┘
        │
        │  ephemeral scratch
        ▼
┌─ .workspace/ ────┐   ← session state
│  session.md       │   Written by: agents
│  scratch/         │   Committed: NO (gitignored)
└───────────────────┘
```

### Agent Roles

| Agent | Responsibility | Writes To |
|---|---|---|
| **Researcher** | Gather requirements, research, context | `features/<x>/research/` |
| **Planner** | Break down work into tasks | `.project/<x>/plan.md`, `tasks.md` |
| **Architect** | Design system structure | `.project/<x>/architecture.md`, `decisions.md` |
| **Backend** | Implement server-side code | code, tests, `tasks.md` status |
| **Frontend** | Implement client-side code | code, tests, `tasks.md` status |
| **Database** | Schema, migrations, queries | code, tests, `tasks.md` status |
| **QA** | Write and run tests | tests, defects in `tasks.md` |
| **Reviewer** | Review code & architecture | verdict in `tasks.md`, `decisions.md` |
| **Documenter** | Docs, progress, knowledge capture | docs, `progress.md`, `.ai/knowledge/` |
| **Release** | Changelog, releases, versioning | `CHANGELOG.md`, `.project/INDEX.md` |

### Enforcement Gates

| Gate | When | What It Checks |
|---|---|---|
| **G1** | Before any code | `tasks.md` exists with acceptance criteria |
| **G2** | Per task | Acceptance criteria pass before marking done |
| **G3** | Before completion | Review verdict must be "approve" |
| **G4** | Every commit | No `.workspace/` leaks, no secrets, clean state |
| **G5** | Destructive ops | User approval required (data drops, force-push, production deploys) |

---

## Tool Compatibility

AI-Kit is **tool-agnostic**. Every major AI coding tool reads `AGENTS.md` as its starting instruction:

| Tool | Entry Point | Type |
|---|---|---|
| OpenAI Codex | `AGENTS.md` | Native |
| Devin | `AGENTS.md` | Native |
| GitHub Copilot | `AGENTS.md` + `.github/copilot-instructions.md` | Native + repo instructions |
| Cursor | `AGENTS.md` + `.cursor/rules/ai-kit.mdc` | Native + always-on rule |
| Windsurf | `AGENTS.md` + `.windsurf/rules/ai-kit.md` | Native + always-on rule |
| Claude Code | `CLAUDE.md` → `AGENTS.md` | Pointer file |
| Gemini CLI | `GEMINI.md` → `AGENTS.md` | Pointer file |

All tool-specific files are **thin pointers** — they contain only "Read AGENTS.md". Never duplicate rules across them.

---

## Repo-Level Automation

These scripts work with **any** IDE or agent because they live in the repo:

| Script | Purpose |
|---|---|
| `.ai/scripts/next-task.sh <feature>` | Prints the next claimable task (unchecked, unclaimed, deps resolved) |
| `.ai/scripts/check-gates.sh staged\|all` | Mechanical Gate G4 check — no workspace leaks, no secrets |
| `.githooks/pre-commit` | Auto-runs G4 on every commit |
| `.github/workflows/gates.yml` | CI: G4 on all files + G2 (runs `test_command` from `.ai/ai.yaml`) |

---

## Stack Conventions

AI-Kit ships **no per-stack playbooks**. Convention sources, in priority order:

1. **Existing project code** — the canonical source; follow its patterns
2. **`.ai/knowledge/conventions.md`** — learned, project-specific conventions
3. **[Agent Skills](https://agentskills.io)** — stack expertise installed in the host tool (Stripe, Postgres, framework skills)

---

## Project Structure

```
AGENTS.md               ← Canonical entry point (every tool starts here)
CLAUDE.md               ← Pointer → AGENTS.md
GEMINI.md               ← Pointer → AGENTS.md
.ai/
  ai.yaml               ← Project config (test_command, stack, etc.)
  models.yaml            ← Model preferences
  rules.yaml             ← Hard rules enforced by gates
  agents/                ← 10 agent role contracts
  modules/               ← Process standards (planning, context, gates, review...)
  knowledge/             ← Cross-feature memory (decisions, conventions, postmortems)
  templates/             ← Brief, plan, tasks, progress templates
  commands/              ← Canonical prompts (plan, implement, review, status)
  scripts/               ← Tool-agnostic automation scripts
features/<x>/            ← Intent: brief.md + research/ + context/
.project/<x>/            ← Execution: plan.md, tasks.md, architecture.md...
.project/INDEX.md        ← Feature lifecycle tracker
.workspace/              ← Ephemeral session state (gitignored)
```

---

## Rules

1. **Planning first** — no code before `.project/<x>/tasks.md` with acceptance criteria (Gate G1)
2. **Minimal context** — load only what the current task needs; rebuild context per task
3. **Review required** — nothing is complete until it passes review (Gate G3)
4. **Write boundaries** — only user + Researcher write to `features/`; execution artifacts stay in `.project/`
5. **Regenerability** — `.project/<x>/` is always regenerable from `features/<x>/`; delete it anytime

---

## Roadmap

- **v0.2** ✅ — Gates, four-tier model, multi-agent coordination, tool compatibility
- **v1.0** 🚧 — Stable release, hardened with real project usage

See [CHANGELOG.md](./CHANGELOG.md) for full history and [ROADMAP.md](./ROADMAP.md) for upcoming plans.

---

<p align="center">
  <sub>Licensed under MIT. Built for AI coding agents, by developers who use them daily.</sub>
</p>
