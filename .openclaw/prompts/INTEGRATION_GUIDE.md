# OpenClaw Prompts - Integration Guide

Diese Anleitung erklärt, wie du die extrahierten OpenClaw-Prompts in verschiedenen IDEs und AI-Assistenten verwenden kannst.

---

## Inhaltsverzeichnis

1. [Cursor](#cursor)
2. [Windsurf](#windsurf)
3. [VS Code](#vs-code)
4. [Claude Code CLI](#claude-code-cli)
5. [Cline](#cline)
6. [Continue](#continue)
7. [Generic AI Assistenten](#generic-ai-assistenten)
8. [Extrahierte Dateien aktualisieren](#extrahierte-dateien-aktualisieren)

---

## Cursor

### Methode 1: .cursorrules Datei

Erstelle eine `.cursorrules` Datei im Projekt-Root:

```bash
# Im Projekt-Root
touch .cursorrules
```

Kopiere den Inhalt von `MASTER_PROMPT.md` in diese Datei:

```bash
# Linux/macOS
cp .openclaw/prompts/MASTER_PROMPT.md .cursorrules

# Windows (PowerShell)
Copy-Item ".openclaw/prompts/MASTER_PROMPT.md" ".cursorrules"
```

### Methode 2: Cursor Settings

1. Öffne Cursor Settings (`Cmd/Ctrl + ,`)
2. Gehe zu `AI` → `General`
3. Füge den Inhalt von `MASTER_PROMPT.md` in das "System Prompt" Feld ein

### Empfohlene Cursor Settings

```json
{
  "cursorai.systemPrompt": "Kopiere MASTER_PROMPT.md Inhalt hier",
  "cursorai.enablePartialAcceptance": true,
  "cursorai.enableSmartCommit": true
}
```

### Windsurf

### Methode 1: .windsurfrc Datei

Erstelle eine `.windsurfrc` Datei im Projekt-Root:

```bash
touch .windsurfrc
```

Kopiere den Inhalt:

```bash
# Linux/macOS
cp .openclaw/prompts/MASTER_PROMPT.md .windsurfrc

# Windows (PowerShell)
Copy-Item ".openclaw/prompts/MASTER_PROMPT.md" ".windsurfrc"
```

### Methode 2: Windsurf Settings

1. Öffne Windsurf Settings (`Cmd/Ctrl + ,`)
2. Gehe zu `AI` → `General`
3. Füge den Inhalt in das "System Prompt" Feld ein

### Empfohlene Windsurf Settings

```json
{
  "windsurf.systemPrompt": "Kopiere MASTER_PROMPT.md Inhalt hier",
  "windsurf.enablePartialAcceptance": true,
  "windsurf.autoApprove": false
}
```

---

## VS Code

### Methode 1: .vscode/system-prompt.md

Erstelle eine `.vscode/system-prompt.md` Datei:

```bash
mkdir -p .vscode
touch .vscode/system-prompt.md
```

Kopiere den Inhalt:

```bash
# Linux/macOS
cp .openclaw/prompts/MASTER_PROMPT.md .vscode/system-prompt.md

# Windows (PowerShell)
Copy-Item ".openclaw/prompts/MASTER_PROMPT.md" ".vscode/system-prompt.md"
```

### Methode 2: GitHub Copilot Chat

1. Erstelle eine `.github/copilot-instructions.md` Datei
2. Füge den relevanten Teil von `MASTER_PROMPT.md` ein

### Methode 3: Continue Extension

Continue unterstützt `~/.continue/system_prompt.md`:

```bash
# Linux/macOS
mkdir -p ~/.continue
cp .openclaw/prompts/MASTER_PROMPT.md ~/.continue/system_prompt.md

# Windows
mkdir -p $HOME/.continue
Copy-Item ".openclaw/prompts/MASTER_PROMPT.md" "$HOME/.continue/system_prompt.md"
```

### Continue config.json

```json
{
  "system_prompt": "Kopiere MASTER_PROMPT.md Inhalt hier",
  "temperature": 0.3,
  "max_tokens": 4096
}
```

---

## Claude Code CLI

### Methode 1: Environment Variable

```bash
export CLAUDE_SYSTEM_PROMPT=$(cat .openclaw/prompts/MASTER_PROMPT.md)
```

### Methode 2: CLAUDE.md Datei

Erstelle eine `CLAUDE.md` im Projekt-Root:

```bash
cp .openclaw/prompts/MASTER_PROMPT.md CLAUDE.md
```

### Methode 3: Anthropic Console

1. Gehe zu [Anthropic Console](https://console.anthropic.com/)
2. Wähle dein Projekt
3. Füge den Inhalt in "System Prompt" ein

---

## Cline

### Settings

1. Öffne Cline Settings
2. Gehe zu `System Prompt`
3. Füge den Inhalt von `MASTER_PROMPT.md` ein

### Empfohlene Cline Settings

```json
{
  "cline.systemPrompt": "Kopiere MASTER_PROMPT.md Inhalt hier",
  "cline.alwaysApproveResubmit": false,
  "cline.maxCost": 0.50
}
```

---

## Continue

### config.json

Erstelle `~/.continue/config.json`:

```json
{
  "system_prompt": "Kopiere MASTER_PROMPT.md Inhalt hier",
  "temperature": 0.2,
  "max_tokens": 8192,
  "model": "claude-sonnet-4-20250514"
}
```

### Alternate Models

```json
{
  "models": [
    {
      "model": "claude-sonnet-4-20250514",
      "system_prompt": "MASTER_PROMPT.md Inhalt"
    },
    {
      "model": "gpt-4o",
      "system_prompt": "MASTER_PROMPT.md Inhalt"
    }
  ]
}
```

---

## Generic AI Assistenten

### ChatGPT / Claude.ai Web

1. Erstelle einen neuen Chat
2. Füge den Inhalt von `MASTER_PROMPT.md` als erstes System-Prompt ein
3. Alle nachfolgenden Nachrichten werden mit diesem Kontext verarbeitet

### Perplexity

1. Gehe zu [Perplexity](https://www.perplexity.ai/)
2. Füge den Inhalt in die "System Instructions" ein (wenn verfügbar)

### Gemini

1. Gehe zu [Gemini](https://gemini.google.com/)
2. Erstelle einen neuen Chat
3. Füge den Inhalt als erstes Prompt ein

---

## Workflow-spezifische Prompts

Für bestimmte Workflows kannst du die spezifischen Prompts laden:

### PR Review Workflow

Kopiere `.openclaw/prompts/workflows/pr-review.md` wenn du einen PR reviewen möchtest.

### PR Prepare Workflow

Kopiere `.openclaw/prompts/workflows/pr-prepare.md` wenn du einen PR für den Merge vorbereiten möchtest.

### PR Merge Workflow

Kopiere `.openclaw/prompts/workflows/pr-merge.md` wenn du einen PR mergen möchtest.

### Upstream Sync Workflow

Kopiere `.openclaw/prompts/workflows/update-clawdbot.md` wenn du deinen Fork mit Upstream synchronisieren möchtest.

---

## Skill-spezifische Prompts

Für bestimmte Tasks kannst du die Skill-Prompts verwenden:

### Coding Agent

```bash
# Lade den Coding Agent Prompt
cat .openclaw/prompts/skills/coding-agent.md
```

### GitHub CLI

```bash
# Lade den GitHub Prompt
cat .openclaw/prompts/skills/github.md
```

### Skill Creation

```bash
# Lade den Skill Creator Prompt
cat .openclaw/prompts/skills/skill-creator.md
```

---

## Extrahierte Dateien aktualisieren

### Automatisch via Script

```bash
#!/bin/bash
# scripts/extract-prompts.sh

echo "Extrahiere Prompts..."

# Workflows
cp -r .agent/workflows/* .openclaw/prompts/workflows/

# Agent Skills
for skill in merge-pr prepare-pr review-pr; do
  cp ".agents/skills/$skill/SKILL.md" ".openclaw/prompts/workflows/$skill.md"
  cp ".agents/skills/$skill/agents/openai.yaml" ".openclaw/prompts/agents/$skill.yaml"
done

# Main Skills
for skill in coding-agent github skill-creator; do
  cp "skills/$skill/SKILL.md" ".openclaw/prompts/skills/$skill.md"
done

# Master Prompt aktualisieren
cat AGENTS.md > .openclaw/prompts/MASTER_PROMPT.md
echo "" >> .openclaw/prompts/MASTER_PROMPT.md
echo "---" >> .openclaw/prompts/MASTER_PROMPT.md
echo "" >> .openclaw/prompts/MASTER_PROMPT.md
cat .openclaw/prompts/workflows/*.md >> .openclaw/prompts/MASTER_PROMPT.md

echo "Prompts extrahiert!"
```

### Manuell

```bash
# Workflows
cp .agent/workflows/update_clawdbot.md .openclaw/prompts/workflows/

# PR Workflows
cp .agents/skills/merge-pr/SKILL.md .openclaw/prompts/workflows/pr-merge.md
cp .agents/skills/prepare-pr/SKILL.md .openclaw/prompts/workflows/pr-prepare.md
cp .agents/skills/review-pr/SKILL.md .openclaw/prompts/workflows/pr-review.md

# Skills
cp skills/coding-agent/SKILL.md .openclaw/prompts/skills/coding-agent.md
cp skills/github/SKILL.md .openclaw/prompts/skills/github.md
cp skills/skill-creator/SKILL.md .openclaw/prompts/skills/skill-creator.md
```

---

## Troubleshooting

### Prompt wird nicht geladen

1. **Pfad prüfen:** Stelle sicher, dass die Datei im richtigen Verzeichnis liegt
2. **Encoding:** UTF-8 Encoding verwenden
3. **Dateiname:** Auf korrekte Schreibweise achten

### Zu lange Prompts

- `MASTER_PROMPT.md` kann gekürzt werden, wenn nötig
- Nur die für dich relevanten Abschnitte behalten

### Performance-Probleme

- Wenn die IDE langsam wird, kürze den Prompt
- Entferne Abschnitte, die du nicht oft brauchst

---

## Tipps & Best Practices

### 1. Graduelle Einführung

Füge den Prompt schrittweise hinzu und beobachte, wie sich das Verhalten ändert.

### 2. Anpassung an deinen Workflow

Passe den Prompt an deine persönlichen Bedürfnisse an:
- Entferne Abschnitte, die du nie brauchst
- Füge deine eigenen Regeln hinzu

### 3. Regelmäßige Updates

Halte deinen Prompt auf dem neuesten Stand:
- Führe `scripts/extract-prompts.sh` regelmäßig aus
- Prüfe auf Änderungen in AGENTS.md

### 4. Versionierung

Wenn du den Prompt anpasst, erstelle eine Kopie:
```bash
cp .openclaw/prompts/MASTER_PROMPT.md .openclaw/prompts/MASTER_PROMPT_personal.md
```

---

## Weitere Ressourcen

- [OpenClaw Docs](https://docs.openclaw.ai)
- [OpenClaw GitHub](https://github.com/openclaw/openclaw)
- [AGENTS.md](../AGENTS.md) - Originale Agent-Anweisungen

---

**Fragen oder Probleme?** Erstelle ein Issue auf GitHub oder kontaktiere die Community.
