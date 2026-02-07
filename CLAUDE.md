# OpenClaw Claude Instructions

**Wichtig:** Die vollständigen Anweisungen findest du in `.openclaw/prompts/MASTER_PROMPT.md`

**Kurzübersicht:**
- Projekt: OpenClaw (https://github.com/openclaw/openclaw)
- Sprache: TypeScript (ESM)
- Linting: Oxlint/Oxfmt (`pnpm check`)
- Build: `pnpm build`
- Tests: `pnpm test` (Vitest)
- Commits: `scripts/committer "<msg>" <file...>`

**Multi-Agent Safety:**
- NICHT `git stash` erstellen/anwenden
- NICHT `git worktree` checkouts erstellen
- NICHT branches wechseln

**Workflows & Skills:**
- `.openclaw/prompts/workflows/` - PR Review/Prepare/Merge
- `.openclaw/prompts/skills/` - Coding-Agent, GitHub, Skill-Creator
