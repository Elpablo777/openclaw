---
name: prepare-pr
description: Prepare a GitHub PR for merge by rebasing onto main, fixing review findings, running gates, committing fixes, and pushing to the PR head branch.
---

# Prepare PR

## Overview

Bereite einen PR-Branch für den Merge vor mit Review-Fixes, grünen Gates und aktualisiertem Head-Branch.

## Inputs

- PR-Nummer oder URL erfragen
- Wenn fehlend, auto-detektieren
- Wenn mehrdeutig, nachfragen

## Safety

- Niemals auf `main` oder `origin/main` pushen
- Nur auf den PR-Head-Branch pushen
- Kein `git push` ohne remote und Branch explizit anzugeben
- Gateway nicht stoppen/killen

## Completion Criteria

- PR Commits auf `origin/main` rebasen
- Alle BLOCKER und IMPORTANT Items aus `.local/review.md` beheben
- Gates ausführen und bestehen
- Prep-Änderungen committen
- Updated HEAD zurück auf PR-Head-Branch pushen
- `.local/prep.md` mit Prep-Zusammenfassung schreiben
- Ausgabe: `PR is ready for /mergepr`

## First: Create a TODO Checklist

Todo-Liste aller Prep-Schritte erstellen, drucken, dann ausführen.

## Setup: Use a Worktree

Isolierten Worktree für alle Prep-Arbeiten verwenden.

```bash
cd ~/openclaw
# Sanity: confirm you are in the repo
git rev-parse --show-toplevel

WORKTREE_DIR=".worktrees/pr-<PR>"
```

Alle Commands im Worktree-Verzeichnis ausführen.

## Load Review Findings (Mandatory)

```bash
if [ -f .local/review.md ]; then
  echo "Found review findings from /reviewpr"
else
  echo "Missing .local/review.md. Run /reviewpr first and save findings."
  exit 1
fi

# Read it
sed -n '1,200p' .local/review.md
```

## Steps

### 1. Identify PR meta (author, head branch, head repo URL)

```bash
gh pr view <PR> --json number,title,author,headRefName,baseRefName,headRepository,body --jq '{number,title,author:.author.login,head:.headRefName,base:.baseRefName,headRepo:.headRepository.nameWithOwner,body}'
```

### 2. Fetch the PR branch tip into a local ref

```bash
git fetch origin pull/<PR>/head:pr-<PR>
```

### 3. Rebase PR commits onto latest main

```bash
# Move worktree to the PR tip first
git reset --hard pr-<PR>

# Rebase onto current main
git fetch origin main
git rebase origin/main
```

### 4. Fix issues from `.local/review.md`

- Alle BLOCKER und IMPORTANT Items beheben
- NITs sind optional
- Umfang eng halten

Fortlaufendes Log in `.local/prep.md` führen:

- Welche Review-Items behoben
- Welche Dateien geändert
- Verhaltensänderungen notieren

### 5. Update `CHANGELOG.md` wenn in Review markiert

### 6. Update docs wenn in Review markiert

### 7. Commit prep fixes

Nur spezifische Dateien stagen:
```bash
git add <file1> <file2> ...
```

Bevorzugtes Commit-Tool:
```bash
committer "fix: <summary> (#<PR>) (thanks @$contrib)" <changed files>
```

### 8. Run full gates before pushing

```bash
pnpm install
pnpm build
pnpm ui:build
pnpm check
pnpm test
```

### 9. Push updates back to the PR head branch

```bash
# Ensure remote for PR head exists
git remote add prhead "$head_repo_url.git" 2>/dev/null || git remote set-url prhead "$head_repo_url.git"

# Use force with lease after rebase
git push --force-with-lease prhead HEAD:$head
```

### 10. Verify PR is not behind main (Mandatory)

```bash
git fetch origin main
git fetch origin pull/<PR>/head:pr-<PR>-verify --force
git merge-base --is-ancestor origin/main pr-<PR>-verify && echo "PR is up to date with main" || echo "ERROR: PR is still behind main, rebase again"
git branch -D pr-<PR>-verify 2>/dev/null || true
```

### 11. Write prep summary artifacts (Mandatory)

`.local/prep.md` aktualisieren mit:
- Current HEAD sha von `git rev-parse HEAD`
- Kurze Bullet-Liste der Änderungen
- Gate-Ergebnisse
- Push-Bestätigung
- Rebase-Verifikationsergebnis

### 12. Output

Diff-Stat-Zusammenfassung:
```bash
git diff --stat origin/main..HEAD
git diff --shortstat origin/main..HEAD
```

Wenn Gates bestanden und Push erfolgreich, drucken:
```
PR is ready for /mergepr
```

## Guardrails

- Worktree nur
- Worktree auf Success nicht löschen ( `/mergepr` kann es wiederverwenden)
- Kein `gh pr merge` ausführen
- Niemals auf main pushen. Nur auf PR-Head-Branch pushen.
- Alle Gates ausführen und bestehen vor dem Pushen.
