# Module: Review

## Purpose
Review procedure and severity model (review is mandatory — rules.yaml: review_required).

## When to Load
Every Reviewer task; engineers may load it for self-review before handoff.

## Review Passes (in order)
1. **Contract** — does the diff satisfy the task's acceptance criteria and the Architect's contracts?
2. **Security** — injection, authz per endpoint, secrets in code, unsafe deserialization, input trust
3. **Correctness** — edge cases, error paths, concurrency, off-by-one, resource cleanup
4. **Consistency** — project conventions, naming, dead code, debug leftovers
5. **Tests** — do tests actually verify the criteria, or just execute the code?

## Severity Model
- **Blocker**: security hole, data loss, broken contract, failing tests → must fix
- **Major**: wrong edge-case behavior, missing error path, untested criterion → fix before merge
- **Minor**: naming, style, docs → note, don't block

## Rules
- Findings reference file:line, state why, and suggest a fix — "this is bad" is not a finding
- Review the diff in codebase context; a correct diff can still break a caller
- Approve-with-notes is valid for minor-only findings

## Output
Verdict (approve / request changes) + findings list, recorded in tasks.md.
