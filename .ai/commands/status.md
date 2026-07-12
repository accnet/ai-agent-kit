# Command: status

Argument: optional `<feature>` — omit for whole-project status.

Report state. Read-only: this command changes nothing.

## Steps
1. Read `.project/INDEX.md` — feature states
2. Per feature (or the given one): run `.ai/scripts/state.sh <feature>` for machine-accurate counts and per-task status (attempts, instance); `.ai/scripts/next-task.sh <feature>` for claimable list
3. Scan tail of `.project/log.jsonl` — recent gate_fail / retry / escalated events worth surfacing
4. Check `.workspace/session.md` — stale? (points at a ticked task or missing feature → say so)
5. Check `.project/<feature>/progress.md` — last entry date

## Output format
```
<feature> [state] — X/Y tasks done
  in-progress: T<n> (instance)
  next claimable: T<n> <title>
  blocked: T<n> ← waiting on T<m>
  open questions: <from tasks.md header, or none>
```
End with: the single most useful next action for the user.
