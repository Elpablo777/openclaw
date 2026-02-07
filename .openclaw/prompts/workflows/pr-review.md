---
name: review-pr
description: Review-only GitHub pull request analysis with the gh CLI. Use when asked to review a PR, provide structured feedback, or assess readiness to land.
---

# Review PR

## Overview

Führe eine gründliche PR-Bewertung durch und gib eine strukturierte Empfehlung für die Bereitschaft zum Merge.

## Inputs

- PR-Nummer oder URL erfragen
- Wenn fehlend, immer fragen (nie auto-detektieren)
- Wenn mehrdeutig, nachfragen

## Safety

- **Niemals** auf `main` oder `origin/main` pushen
- Kein `git push` während der Review
- Gateway nicht stoppen/killen

## Completion Criteria

- Commands im Worktree ausführen und PR direkt inspizieren
- Strukturierte Review-Sektionen A bis J produzieren
- Full Review in `.local/review.md` speichern

## First: Create a TODO Checklist

Todo-Liste aller Review-Schritte erstellen, drucken, dann ausführen.

## Setup: Use a Worktree

Isolierten Worktree für alle Review-Arbeiten verwenden.

```bash
cd ~/Development/openclaw
# Sanity: confirm you are in the repo
git rev-parse --show-toplevel

WORKTREE_DIR=".worktrees/pr-<PR>"
git fetch origin main

# Reuse existing worktree if it exists, otherwise create new
if [ -d "$WORKTREE_DIR" ]; then
  cd "$WORKTREE_DIR"
  git checkout temp/pr-<PR> 2>/dev/null || git checkout -b temp/pr-<PR>
  git fetch origin main
  git reset --hard origin/main
else
  git worktree add "$WORKTREE_DIR" -b temp/pr-<PR> origin/main
  cd "$WORKTREE_DIR"
fi

# Create local scratch space that persists across /reviewpr to /preparepr to /mergepr
mkdir -p .local
```

Alle Commands im Worktree-Verzeichnis ausführen. Auf `origin/main` starten, um existierende Implementierungen vor PR-Code zu prüfen.

## Steps

### 1. Identify PR meta and context

```bash
gh pr view <PR> --json number,title,state,isDraft,author,baseRefName,headRefName,headRepository,url,body,labels,assignees,reviewRequests,files,additions,deletions --jq '{number,title,url,state,isDraft,author:.author.login,base:.baseRefName,head:.headRefName,headRepo:.headRepository.nameWithOwner,additions,deletions,files:.files|length,body}'
```

### 2. Check if this already exists in main before looking at the PR branch

```bash
# Use keywords from the PR title and changed files
rg -n "<keyword_from_pr_title>" -S src packages apps ui || true
rg -n "<function_or_component_name>" -S src packages apps ui || true

git log --oneline --all --grep="<keyword_from_pr_title>" | head -20
```

Wenn es bereits existiert, als BLOCKER oder mindestens IMPORTANT markieren.

### 3. Claim the PR

```bash
gh_user=$(gh api user --jq .login)
gh pr edit <PR> --add-assignee "$gh_user"
```

### 4. Read the PR description carefully

Ziel, Umfang und fehlenden Kontext zusammenfassen.

### 5. Read the diff thoroughly

```bash
gh pr diff <PR>
```

### 6. Validate the change is needed and valuable

Ehrlich sein. Low value AI slop ansprechen.

### 7. Evaluate implementation quality

Korrektheit, Design, Performance und Ergonomie prüfen.

### 8. Perform a security review

Auth, Input-Validation, Secrets, Dependencies, Tool-Safety und Privacy prüfen.

### 9. Review tests and verification

Was existiert, was fehlt, was wäre ein minimaler Regressionstest.

### 10. Check docs

Ob PR Code mit zugehöriger Dokumentation berührt (README, Docs, API-Docs, Config-Beispiele).

- Wenn Docs existieren für geänderten Bereich und PR sie nicht aktualisiert → IMPORTANT
- Wenn PR neue Features oder Config-Optionen ohne Docs hinzufügt → IMPORTANT

### 11. Check changelog

Ob `CHANGELOG.md` existiert und ob der PR einen Eintrag verdient.

### 12. Answer the key question

Ob `/preparepr` Probleme beheben kann oder Contributor PR aktualisieren muss.

### 13. Save findings to the worktree

Vollständige strukturierte Review-Sektionen A bis J in `.local/review.md` schreiben.

### 14. Output the structured review

A) TL;DR Empfehlung
- Eines von: READY FOR /preparepr | NEEDS WORK | NEEDS DISCUSSION | NOT USEFUL (CLOSE)
- 1-3 Sätze

B) Was geändert wurde

C) Was gut ist

D) Security findings

E) Concerns oder questions (actionable)
- Nummerierte Liste
- Jedes Item als BLOCKER, IMPORTANT oder NIT markieren

F) Tests

G) Docs status

H) Changelog

I) Follow ups (optional)

J) Suggested PR comment (optional)

## Guardrails

- Worktree nur
- Worktree nach Review nicht löschen
- Nur Review, nicht mergen, nicht pushen
