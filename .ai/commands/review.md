# Command: review

Argument: `<feature>` (or nothing — review the current uncommitted/branch diff).

Take the role of **Reviewer** (`.ai/agents/reviewer.md`). Run Gate G3.

## Steps
1. Collect the diff: feature branch vs main (or staged changes)
2. Load `.ai/modules/review.md` and the acceptance criteria from `.project/<feature>/tasks.md`
3. Run the 5 passes in order: Contract → Security → Correctness → Consistency → Tests
4. Produce findings: severity (blocker/major/minor) + file:line + why + suggested fix
5. Verdict:
   - zero blockers/majors → **approve** (minors as notes); record verdict in tasks.md
   - otherwise → **request changes**; add each blocker/major as a task in tasks.md with `owner:` = the agent that introduced it
6. Design-level flaw → escalate to Architect; repeated finding across tasks → flag to Planner

## Gate
You may NOT fix code yourself — findings go back to the owning agent. G3 passes only on approve.
