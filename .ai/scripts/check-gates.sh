#!/usr/bin/env bash
# check-gates.sh — mechanical checks for Gate G4 (commit hygiene)
# Usage:
#   .ai/scripts/check-gates.sh staged   # check files staged for commit (pre-commit hook)
#   .ai/scripts/check-gates.sh all      # check all tracked files (CI)
# Checks: no .workspace/ files committed; no .workspace/ path references
# outside the kit's own definitions; no obvious secrets.
set -uo pipefail

MODE="${1:-staged}"
FAIL=0

if [ "$MODE" = "staged" ]; then
  FILES=$(git diff --cached --name-only --diff-filter=ACM)
else
  FILES=$(git ls-files)
fi

[ -z "$FILES" ] && exit 0

# G4.1 — no .workspace/ content committed
ws_files=$(echo "$FILES" | grep -E '^\.workspace/' || true)
if [ -n "$ws_files" ]; then
  echo "G4 FAIL: .workspace/ files must never be committed:" >&2
  echo "$ws_files" >&2
  FAIL=1
fi

# G4.2 — no .workspace/ references outside kit definitions
# (the kit itself defines the rule, so its own docs are exempt)
EXEMPT='^(\.ai/|\.agents/|AGENTS\.md|README\.md|ROADMAP\.md|CHANGELOG\.md|CLAUDE\.md|GEMINI\.md|\.gitignore|\.githooks/|\.github/|\.cursor/|\.windsurf/)'
for f in $FILES; do
  echo "$f" | grep -qE "$EXEMPT" && continue
  [ -f "$f" ] || continue
  if grep -qE '\.workspace/' "$f" 2>/dev/null; then
    echo "G4 FAIL: $f references .workspace/ (ephemeral paths must not leak into committed files)" >&2
    FAIL=1
  fi
done

# G4.3 — obvious secrets
SECRET_PATTERNS='-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----|AKIA[0-9A-Z]{16}|sk-[A-Za-z0-9]{20,}|ghp_[A-Za-z0-9]{36}|xox[baprs]-[A-Za-z0-9-]+'
for f in $FILES; do
  [ -f "$f" ] || continue
  case "$f" in *.png|*.jpg|*.jpeg|*.gif|*.pdf|*.zip|*.ico) continue ;; esac
  hits=$(grep -nE -e "$SECRET_PATTERNS" "$f" 2>/dev/null | head -3 || true)
  if [ -n "$hits" ]; then
    echo "G4 FAIL: possible secret in $f:" >&2
    echo "$hits" >&2
    FAIL=1
  fi
done

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ "$FAIL" -ne 0 ]; then
  bash "$SCRIPT_DIR/log-event.sh" gate_fail - - "check-gates" "G4 blocked ($MODE mode)" 2>/dev/null || true
  echo "" >&2
  echo "Gate G4 blocked this commit. Fix the issues above." >&2
  echo "(Only the user may waive a gate, explicitly, per instance — see .ai/modules/gates.md)" >&2
  exit 1
fi
exit 0
