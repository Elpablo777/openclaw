# OpenClaw Prompts & Instructions

Dieses Verzeichnis enthält alle extrahierten Prompts, Anweisungen und Workflows aus dem OpenClaw-Projekt, optimiert für die Verwendung in IDEs wie Cursor, Windsurf, VS Code und anderen AI-Assistenten.

## Verzeichnisstruktur

```
.openclaw/prompts/
├── README.md                           # Diese Datei
├── MASTER_PROMPT.md                     # Vollständiger Master-Prompt
├── INTEGRATION_GUIDE.md                # Anleitung für IDE-Integration
├── antigravity.md                      # Antigravity-spezifische Konfiguration
│
├── workflows/                          # Workflow-Dokumentationen
│   ├── update-clawdbot.md              # Fork mit Upstream synchronisieren
│   ├── pr-merge.md                     # PR Merge Workflow
│   ├── pr-prepare.md                   # PR Prepare Workflow
│   └── pr-review.md                    # PR Review Workflow
│
├── skills/                             # Skill-basierte Prompts
│   ├── coding-agent.md                 # Coding-Agenten steuern
│   ├── github.md                       # GitHub CLI verwenden
│   └── skill-creator.md                # Skills erstellen
│
└── agents/                             # Agent-Konfigurationen
    ├── merge-pr.yaml
    ├── prepare-pr.yaml
    └── review-pr.yaml
```

## IDE-Konfigurationsdateien (Projekt-Root)

Die folgenden Dateien wurden im Projekt-Root erstellt:

| Datei | IDE | Zweck |
|-------|-----|-------|
| `.cursorrules` | Cursor | Project-level AI rules |
| `.windsurfrc` | Windsurf | Project-level AI configuration |
| `.vscode/system-prompt.md` | VS Code + Copilot | System prompt |
| `.github/copilot-instructions.md` | GitHub Copilot | Chat instructions |
| `CLAUDE.md` | Claude Code CLI | Main instructions |

## Verwendung

### Cursor

Die `.cursorrules` Datei wird automatisch von Cursor erkannt. Alternativ kannst du den Inhalt in die Cursor Settings kopieren.

### Windsurf

Die `.windsurfrc` Datei wird automatisch von Windsurf erkannt.

### VS Code + GitHub Copilot

Kopiere den Inhalt von `.vscode/system-prompt.md` in die GitHub Copilot Chat Settings oder erstelle `.github/copilot-instructions.md`.

### Claude Code CLI

Die `CLAUDE.md` Datei wird automatisch von Claude Code CLI erkannt.

### Antigravity

Siehe `.openclaw/prompts/antigravity.md` für Antigravity-spezifische Konfiguration.

## Prompts-Kategorien

### 1. Master Prompt (MASTER_PROMPT.md)
Der vollständige Master-Prompt enthält alle OpenClaw-spezifischen Regeln und ist für die tägliche Arbeit optimiert.

### 2. Workflows
Detaillierte Schritt-für-Schritt-Anleitungen für komplexe Aufgaben:
- **update-clawdbot**: Fork mit Upstream synchronisieren
- **pr-merge**: PRs via Squash mergen
- **pr-prepare**: PRs für den Merge vorbereiten
- **pr-review**: PRs überprüfen

### 3. Skills
Skill-basierte Prompts für spezifische Funktionsbereiche:
- **coding-agent**: Coding-Agenten steuern
- **github**: GitHub CLI verwenden
- **skill-creator**: Neue Skills erstellen

### 4. Agents
Agent-Konfigurationen für die verschiedenen OpenClaw-Agents (YAML-Format).

### 5. Antigravity (antigravity.md)
Spezifische Konfiguration für Google Antigravity / Project IDX mit besonderem Fokus auf Tool Schema Guardrails.

## Aktualisierung

Um die Prompts zu aktualisieren, führe diese Befehle aus:

```bash
# Workflows extrahieren
cp -r .agent/workflows/* .openclaw/prompts/workflows/

# Agent-Skills extrahieren
cp -r .agents/skills/*/SKILL.md .openclaw/prompts/workflows/
cp -r .agents/skills/*/agents/openai.yaml .openclaw/prompts/agents/

# Relevante Skills extrahieren
for skill in coding-agent github skill-creator; do
  cp "skills/$skill/SKILL.md" ".openclaw/prompts/skills/$skill.md"
done
```

## Kurzreferenz

| Befehl | Beschreibung |
|--------|-------------|
| `pnpm install` | Dependencies installieren |
| `pnpm build` | TypeScript kompilieren |
| `pnpm check` | Lint/Format prüfen |
| `pnpm test` | Tests ausführen |
| `bun <file.ts>` | TypeScript mit Bun ausführen |

## Weiterführende Links

- [OpenClaw Docs](https://docs.openclaw.ai)
- [OpenClaw GitHub](https://github.com/openclaw/openclaw)
- [AGENTS.md](../AGENTS.md) - Originale Agent-Anweisungen
