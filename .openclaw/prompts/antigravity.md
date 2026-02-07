# OpenClaw Configuration for Antigravity

**Version:** 1.0  
**Für:** Google Antigravity / Project IDX

---

## Tool Schema Guardrails (Antigravity)

**WICHTIG:** Für Antigravity gelten spezielle Regeln für Tool-Schemas:

- `Type.Union` in Tool-Input-Schemes **vermeiden**
- Keine `anyOf`/`oneOf`/`allOf`
- `stringEnum`/`optionalStringEnum` für String-Listen verwenden
- `Type.Optional(...)` statt `... | null`
- Top-level Tool-Schema: `type: "object"` mit `properties`
- `format` Property Namen in Tool-Schemes **vermeiden** (Validatoren lehnen ab)

## Projektgrundlagen

### Repository
- **Repo:** https://github.com/openclaw/openclaw
- **Sprache:** TypeScript (ESM)

### Coding-Stil
- Striktes Typing, `any` vermeiden
- Oxlint/Oxfmt (`pnpm check`)
- ~700 LOC Ziel pro Datei

## Build & Test

```bash
pnpm install          # Dependencies
pnpm build            # TypeScript
pnpm check            # Lint/Format
pnpm test             # Tests
bun <file.ts>         # Bun für TypeScript
```

## Commit & PR

- Commits: `scripts/committer "<msg>" <file...>`
- **NICHT** `git stash` erstellen/anwenden
- **NICHT** `git worktree` checkouts erstellen

## Workflow-Referenzen

- `.openclaw/prompts/workflows/pr-review.md`
- `.openclaw/prompts/workflows/pr-prepare.md`
- `.openclaw/prompts/workflows/pr-merge.md`

---

**Vollständiger Prompt:** `.openclaw/prompts/MASTER_PROMPT.md`
