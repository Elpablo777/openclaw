---
description: Update Clawdbot from upstream when branch has diverged (ahead/behind)
---

# Clawdbot Upstream Sync Workflow

Verwende diesen Workflow wenn dein Fork vom Upstream divergiert hat (z.B. "18 commits ahead, 29 commits behind").

## Quick Reference

```bash
# Check divergence status
git fetch upstream && git rev-list --left-right --count main...upstream/main

# Full sync (rebase preferred)
git fetch upstream && git rebase upstream/main && pnpm install && pnpm build && ./scripts/restart-mac.sh

# Check for Swift 6.2 issues after sync
grep -r "FileManager\.default\|Thread\.isMainThread" src/ apps/ --include="*.swift"
```

---

## Step 1: Assess Divergence

```bash
git fetch upstream
git log --oneline --left-right main...upstream/main | head -20
```

Dies zeigt:
- `<` = deine lokalen Commits (ahead)
- `>` = Upstream Commits, die dir fehlen (behind)

**Entscheidung:**
- Wenige lokale, viele Upstream → **Rebase** (sauberer Verlauf)
- Viele lokale Commits oder geteilter Branch → **Merge** (erhält Verlauf)

---

## Step 2A: Rebase Strategy (Bevorzugt)

Spielt deine Commits oben auf Upstream auf. Ergibt linearen Verlauf.

```bash
# Ensure working tree is clean
git status

# Rebase onto upstream
git rebase upstream/main
```

### Handling Rebase Conflicts

```bash
# When conflicts occur:
# 1. Fix conflicts in the listed files
# 2. Stage resolved files
git add <resolved-files>

# 3. Continue rebase
git rebase --continue

# If a commit is no longer needed (already in upstream):
git rebase --skip

# To abort and return to original state:
git rebase --abort
```

### Common Conflict Patterns

| File             | Resolution                                       |
| ---------------- | ------------------------------------------------ |
| `package.json`   | Take upstream deps, keep local scripts if needed |
| `pnpm-lock.yaml` | Accept upstream, regenerate with `pnpm install`  |
| `*.patch` files  | Usually take upstream version                    |
| Source files     | Merge logic carefully, prefer upstream structure |

---

## Step 2B: Merge Strategy (Alternative)

Erhält den gesamten Verlauf mit einem Merge-Commit.

```bash
git merge upstream/main --no-edit
```

Resolve conflicts same as rebase, dann:
```bash
git add <resolved-files>
git commit
```

---

## Step 3: Rebuild Everything

```bash
# Install dependencies (regenerates lock if needed)
pnpm install

# Build TypeScript
pnpm build

# Build UI assets
pnpm ui:build

# Run diagnostics
pnpm clawdbot doctor
```

---

## Step 4: Rebuild macOS App

```bash
# Full rebuild, sign, and launch
./scripts/restart-mac.sh

# Or just package without restart
pnpm mac:package
```

### Install to /Applications

```bash
# Kill running app
pkill -x "Clawdbot" || true

# Move old version
mv /Applications/Clawdbot.app /tmp/Clawdbot-backup.app

# Install new build
cp -R dist/Clawdbot.app /Applications/

# Launch
open /Applications/Clawdbot.app
```

---

## Step 4A: Verify macOS App & Agent

```bash
# Check gateway health
pnpm clawdbot health

# Verify no zombie processes
ps aux | grep -E "(clawdbot|gateway)" | grep -v grep

# Test agent functionality by sending a verification message
pnpm clawdbot agent --message "Verification: macOS app rebuild successful - agent is responding." --session-id YOUR_TELEGRAM_SESSION_ID

# Confirm the message was received on Telegram
```

**Wichtig:** Immer auf die Telegram-Verifizierungsnachricht warten.

---

## Step 5: Handle Swift/macOS Build Issues (Common After Upstream Sync)

Upstream Updates können Swift 6.2 / macOS 26 SDK Inkompatibilitäten einführen.

### Common Swift 6.2 Fixes

**FileManager.default Deprecation:**

```bash
# Search for deprecated usage
grep -r "FileManager\.default" src/ apps/ --include="*.swift"

# Replace with proper initialization
# OLD: FileManager.default
# NEW: FileManager()
```

**Thread.isMainThread Deprecation:**

```bash
# Search for deprecated usage
grep -r "Thread\.isMainThread" src/ apps/ --include="*.swift"

# Replace with modern concurrency check
# OLD: Thread.isMainThread
# NEW: await MainActor.run { ... } or DispatchQueue.main.sync { ... }
```

### Peekaboo Submodule Fixes

```bash
# Check Peekaboo for concurrency issues
cd src/canvas-host/a2ui
grep -r "Thread\.isMainThread\|FileManager\.default" . --include="*.swift"

# Fix and rebuild submodule
pnpm canvas:a2ui:bundle
```

---

## Step 6: Verify & Push

```bash
# Verify everything works
pnpm clawdbot health
pnpm test

# Push (force required after rebase)
git push origin main --force-with-lease

# Or regular push after merge
git push origin main
```

---

## Troubleshooting

### Build Fails After Sync

```bash
# Clean and rebuild
rm -rf node_modules dist
pnpm install
pnpm build
```

### Type Errors (Bun/Node Incompatibility)

Common issue: `fetch.preconnect` type mismatch. Fix by using `FetchLike` type instead of `typeof fetch`.

### macOS App Crashes on Launch

Usually resource bundle mismatch. Full rebuild required:
```bash
cd apps/macos && rm -rf .build .swiftpm
./scripts/restart-mac.sh
```

### Patch Failures

```bash
# Check patch status
pnpm install 2>&1 | grep -i patch
```
