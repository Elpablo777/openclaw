#!/usr/bin/env bash
set -euo pipefail

# Sync OpenClaw Prompts Script
# Führt dieses Script aus, um die Prompts aus dem Original-Projekt zu extrahieren

echo "🔄 Syncing OpenClaw Prompts..."

# Workflows extrahieren
echo "📦 Extracting workflows..."
cp -r .agent/workflows/* .openclaw/prompts/workflows/ 2>/dev/null || echo "⚠️  No workflows to sync"

# Agent Skills extrahieren
echo "📦 Extracting agent skills..."
cp -r .agents/skills/*/SKILL.md .openclaw/prompts/workflows/ 2>/dev/null || echo "⚠️  No agent skills to sync"
cp -r .agents/skills/*/agents/openai.yaml .openclaw/prompts/agents/ 2>/dev/null || echo "⚠️  No agent configs to sync"

# Main Skills extrahieren
echo "📦 Extracting main skills..."
for skill in coding-agent github skill-creator; do
  if [ -f "skills/$skill/SKILL.md" ]; then
    cp "skills/$skill/SKILL.md" ".openclaw/prompts/skills/$skill.md"
    echo "   ✅ Synced $skill"
  fi
done

# IDE-Konfigs aktualisieren
echo "📦 Updating IDE configs..."
cp .openclaw/prompts/MASTER_PROMPT.md .cursorrules 2>/dev/null || echo "⚠️  No MASTER_PROMPT.md"
cp .openclaw/prompts/MASTER_PROMPT.md .windsurfrc 2>/dev/null || echo "⚠️  No MASTER_PROMPT.md"
cp .openclaw/prompts/MASTER_PROMPT.md .vscode/system-prompt.md 2>/dev/null || echo "⚠️  No MASTER_PROMPT.md"
cp .openclaw/prompts/MASTER_PROMPT.md .github/copilot-instructions.md 2>/dev/null || echo "⚠️  No MASTER_PROMPT.md"

# Kurzfassung für CLAUDE.md erstellen
echo "📦 Updating CLAUDE.md..."
cat > CLAUDE.md << 'EOF'
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
EOF

# Git add und commit
echo "📝 Committing changes..."
git add -A .openclaw/prompts/ .cursorrules .windsurfrc .vscode/system-prompt.md .github/copilot-instructions.md CLAUDE.md 2>/dev/null

if git diff --cached --quiet; then
  echo "✅ Keine Änderungen gefunden"
else
  git commit -m "chore: sync prompts from upstream $(date '+%Y-%m-%d')"
  echo "✅ Changes committed"

  echo "🚀 Pushing to origin..."
  git push origin main
  echo "✅ Pushed to fork"
fi

echo "✨ Sync complete!"
