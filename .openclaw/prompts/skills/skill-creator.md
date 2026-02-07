# Skill Creator

Erstelle oder aktualisiere AgentSkills für OpenClaw.

## Was Skills bieten

1. **Spezialisierte Workflows** - Mehrschritt-Verfahren für spezifische Domänen
2. **Tool-Integrationen** - Anweisungen für spezifische Dateiformate oder APIs
3. **Domänenexpertise** - Unternehmensspezifisches Wissen, Schemas, Business-Logik
4. ** Gebündelte Ressourcen** - Scripts, Referenzen und Assets

## Core Principles

### Concise is Key

Der Context-Window ist ein öffentliches Gut. Skills teilen den Context-Window mit allem anderen.

**Default Annahme: Das Model ist bereits sehr smart.** Nur Kontext hinzufügen, den das Model nicht schon hat.

Jedes Stück Information hinterfragen: "Braucht das Model das wirklich?"

### Angemessene Freiheitsgrade

**Hohe Freiheit (textbasierte Anweisungen):** Wenn mehrere Ansätze valide sind.

**Mittlere Freiheit (Pseudocode oder Scripts mit Parametern):** Wenn ein bevorzugtes Pattern existiert.

**Niedrige Freiheit (spezifische Scripts, wenige Parameter):** Wenn Operationen fehleranfällig sind.

## Anatomy of a Skill

```
skill-name/
├── SKILL.md (required)
│   ├── YAML frontmatter metadata (required)
│   │   ├── name: (required)
│   │   └── description: (required)
│   └── Markdown instructions (required)
└── Bundled Resources (optional)
    ├── scripts/          - Executable code (Python/Bash/etc.)
    ├── references/       - Documentation
    └── assets/           - Files used in output
```

## SKILL.md Frontmatter

```yaml
---
name: skill-name
description: "Comprehensive description of what the skill does and when to use it. Include both what the Skill does and specific triggers/contexts for when to use it."
---
```

## Progressive Disclosure Design Principle

Skills nutzen ein dreistufiges Ladesystem:

1. **Metadata (name + description)** - Immer im Context
2. **SKILL.md body** - Wenn Skill triggered (<5k words)
3. **Bundled resources** - Bei Bedarf (unlimited)

## Skill Creation Process

1. **Verstehe den Skill mit konkreten Beispielen**
2. **Plane wiederverwendbare Skill-Inhalte**
3. **Initialisiere den Skill** (`scripts/init_skill.py`)
4. **Editiere den Skill** (Resources implementieren, SKILL.md schreiben)
5. **Package den Skill** (`scripts/package_skill.py`)
6. **Iteriere** basierend auf realer Nutzung

## Skill Naming

- Kleinbuchstaben, Ziffern und Bindestriche nur
- Unter 64 Zeichen
- Kurze, Verb-geleitete Phrasen bevorzugen
- Nach Tool namespacen wenn es Klarheit verbessert

## Step 1: Understanding with Examples

Relevante Fragen:
- Welche Funktionalität sollte der Skill unterstützen?
- Wie würde der Skill verwendet werden?
- Was würde ein Benutzer sagen, um den Skill zu triggern?

## Step 2: Planning Reusable Contents

Analysiere jedes Beispiel:
1. Wie führe ich das Beispiel von Grund auf aus?
2. Welche Scripts, References und Assets wären hilfreich?

## Step 3: Initialize Skill

```bash
scripts/init_skill.py <skill-name> --path <output-directory> [--resources scripts,references,assets] [--examples]
```

## Step 4: Edit the Skill

**Schreibrichtlinien:** Immer Imperativ/Infinitiv verwenden.

## Step 5: Packaging

```bash
scripts/package_skill.py <path/to/skill-folder>
```

Das Packaging-Skript:
1. **Validiert** den Skill
2. **Package** wenn Validation besteht

## Step 6: Iterate

Nach dem Testen können Nutzer Verbesserungen anfragen.
