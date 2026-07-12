# Tasks — example

Intent: feature | Size: standard
Goal: (placeholder demonstrating structure — see .ai/templates/tasks.md)
Out of scope: —
Open questions: none

## Tasks
- [ ] T1 Example task | owner: backend | scope: S | needs: - | files: src/example.*
  - Accept: example acceptance criterion

## Tail
- [ ] T96 QA: integration test | owner: qa | needs: T1 | files: tests/
- [ ] T97 Review (G3) | owner: reviewer | needs: T96 | files: -
- [ ] T98 Docs + graduation pass | owner: documenter | needs: T97 | files: -
- [ ] T99 INDEX.md state update | owner: release | needs: T98 | files: -
