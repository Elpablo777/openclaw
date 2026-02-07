# Coding Agent

Verwende **bash** (mit optionalem background mode) für alle Coding-Agenten-Arbeiten.

## PTY Mode Required!

Coding-Agenten (Codex, Claude Code, Pi) sind **interaktive Terminal-Anwendungen**, die ein Pseudo-Terminal (PTY) brauchen.

**Immer `pty:true` verwenden:**

```bash
# ✅ Correct - with PTY
bash pty:true command:"codex exec 'Your prompt'"

# ❌ Wrong - no PTY, agent may break
bash command:"codex exec 'Your prompt'"
```

### Bash Tool Parameters

| Parameter    | Type    | Description                                                                 |
| ------------ | ------- | --------------------------------------------------------------------------- |
| `command`    | string  | The shell command to run                                                    |
| `pty`        | boolean | **Use for coding agents!** Allocates a pseudo-terminal for interactive CLIs |
| `workdir`    | string  | Working directory                                                          |
| `background` | boolean | Run in background, returns sessionId for monitoring                       |
| `timeout`    | number  | Timeout in seconds (kills process on expiry)                                |

## Quick Start: One-Shot Tasks

```bash
# Quick chat (Codex needs a git repo!)
SCRATCH=$(mktemp -d) && cd $SCRATCH && git init && codex exec "Your prompt here"

# Or in a real project - with PTY!
bash pty:true workdir:~/Projects/myproject command:"codex exec 'Add error handling to the API calls'"
```

## The Pattern: workdir + background + pty

```bash
# Start agent in target directory (with PTY!)
bash pty:true workdir:~/project background:true command:"codex exec --full-auto 'Build a snake game'"

# Monitor progress
process action:log sessionId:XXX

# Check if done
process action:poll sessionId:XXX

# Send input if agent asks a question
process action:write sessionId:XXX data:"y"

# Submit with Enter
process action:submit sessionId:XXX data:"yes"

# Kill if needed
process action:kill sessionId:XXX
```

## Rules

1. **Always use pty:true** - coding agents need a terminal!
2. **Respect tool choice** - if user asks for Codex, use Codex
3. **Be patient** - don't kill sessions because they're "slow"
4. **Monitor with process:log** - check progress without interfering
5. **--full-auto for building** - auto-approves changes
6. **Parallel is OK** - run many Codex processes at once for batch work
7. **NEVER start Codex in ~/clawd/** - it'll read your soul docs!
8. **NEVER checkout branches in ~/Projects/openclaw/** - that's the LIVE OpenClaw instance!

## Progress Updates

When spawning coding agents in background:
- Send 1 short message when you start
- Update when something changes (milestone completes, agent asks, agent finishes)
- If you kill a session, immediately say you killed it and why

## Auto-Notify on Completion

For long-running background tasks:
```
... your task here.

When completely finished, run this command to notify me:
openclaw gateway wake --text "Done: [brief summary]" --mode now
```
