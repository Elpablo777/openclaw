---
name: merge-pr
description: Merge a GitHub PR via squash after /preparepr. Use when asked to merge a ready PR.
---

# Merge PR

## Overview

Mergt einen vorbereiteten PR via `gh pr merge --squash` und räumt den Worktree auf.

## Inputs

- PR-Nummer oder URL erfragen
- Wenn fehlend, auto-detektieren
- Wenn mehrdeutig, nachfragen

## Safety

- `gh pr merge --squash` als einzigen Pfad zu `main` verwenden
- Kein `git push` während des Merges
- Gateway nicht stoppen

## Execution Rule

Workflow ausführen. Nicht nach dem Drucken der Todo-Liste stoppen.

## Known Footguns

- Wenn "fatal: not a git repository", falsches Verzeichnis. `~/openclaw` verwenden, nicht `~/openclaw`.
- `.local/review.md` und `.local/prep.md` im Worktree lesen. Nicht überspringen.
- `.worktrees/pr-<PR>` erst nach erfolgreichem Merge aufräumen

## Completion Criteria

- `gh pr merge` erfolgreich
- PR-Status `MERGED`, nie `CLOSED`
- Merge SHA aufzeichnen
- Cleanup erst nach Merge-Erfolg ausführen

## First: Create a TODO Checklist

Todo-Liste aller Merge-Schritte erstellen, drucken, dann ausführen.

## Setup: Use a Worktree

Isolierten Worktree für alle Merge-Arbeiten verwenden.

```bash
cd ~/Development/openclaw
# Sanity: confirm you are in the repo
git rev-parse --show-toplevel

WORKTREE_DIR=".worktrees/pr-<PR>"
```

Alle Commands im Worktree-Verzeichnis ausführen.

## Load Local Artifacts (Mandatory)

Erwartete Dateien von früheren Schritten:

- `.local/review.md` von `/reviewpr`
- `.local/prep.md` von `/preparepr`

```bash
ls -la .local || true

if [ -f .local/review.md ]; then
  echo "Found .local/review.md"
  sed -n '1,120p' .local/review.md
else
  echo "Missing .local/review.md. Stop and run /reviewpr, then /preparepr."
  exit 1
fi

if [ -f .local/prep.md ]; then
  echo "Found .local/prep.md"
  sed -n '1,120p' .local/prep.md
else
  echo "Missing .local/prep.md. Stop and run /preparepr first."
  exit 1
fi
```

## Steps

### 1. Identify PR meta

```bash
gh pr view <PR> --json number,title,state,isDraft,author,headRefName,baseRefName,headRepository,body --jq '{number,title,state,isDraft,author:.author.login,head:.headRefName,base:.baseRefName,headRepo:.headRepository.nameWithOwner,body}'
contrib=$(gh pr view <PR> --json author --jq .author.login)
head=$(gh pr view <PR> --json headRefName --jq .headRefName)
head_repo_url=$(gh pr view <PR> --json headRepository --jq .headRepository.url)
```

### 2. Run sanity checks

Stoppen wenn:

- PR ist Draft
- Required Checks scheitern
- Branch ist hinter main

```bash
# Checks
gh pr checks <PR>

# Check behind main
git fetch origin main
git fetch origin pull/<PR>/head:pr-<PR>
git merge-base --is-ancestor origin/main pr-<PR> || echo "PR branch is behind main, run /preparepr"
```

Wenn etwas scheitert, stoppen und sagen, dass `/preparepr` ausgeführt werden soll.

### 3. Merge PR and delete branch

Wenn Checks noch laufen, `--auto` verwenden um Merge zu queued.

```bash
# Check status first
check_status=$(gh pr checks <PR> 2>&1)
if echo "$check_status" | grep -q "pending\|queued"; then
  echo "Checks still running, using --auto to queue merge"
  gh pr merge <PR> --squash --delete-branch --auto
  echo "Merge queued. Monitor with: gh pr checks <PR> --watch"
else
  gh pr merge <PR> --squash --delete-branch
fi
```

### 4. Get merge SHA

```bash
merge_sha=$(gh pr view <PR> --json mergeCommit --jq '.mergeCommit.oid')
echo "merge_sha=$merge_sha"
```

### 5. Optional comment

```bash
gh pr comment <PR> -F - <<'EOF'
Merged via squash.

- Merge commit: $merge_sha

Thanks @$contrib!
EOF
```

### 6. Verify PR state is MERGED

```bash
gh pr view <PR> --json state --jq .state
```

### 7. Clean up worktree only on success

Cleanup nur ausführen wenn Schritt 6 `MERGED` zurückgibt.

```bash
cd ~/Development/openclaw

git worktree remove ".worktrees/pr-<PR>" --force

git branch -D temp/pr-<PR> 2>/dev/null || true
git branch -D pr-<PR> 2>/dev/null || true
```

## Guardrails

- Worktree nur
- PRs nicht schließen
- Mit `MERGED` Status beenden
- Cleanup nur nach Merge-Erfolg
- Niemals auf main pushen. Nur `gh pr merge --squash` verwenden.
- Kein `git push` während dieses Commands.
