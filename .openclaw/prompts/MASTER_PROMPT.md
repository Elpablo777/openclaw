# OpenClaw Master Prompt

**Version:** 1.0.0  
**Für:** Cursor, Windsurf, VS Code und andere AI-Assistenten  
**Basierend aufENTS.md, SKILL.md Date:** AGien, Workflow-Dokumentationen

---

## Überblick

Du arbeitest am OpenClaw-Projekt, einem Open-Source-Projekt für AI-gesteuerte Automatisierung. Dieser Prompt enthält alle wesentlichen Regeln, Konventionen und Best Practices für die Arbeit an diesem Projekt.

## Projektgrundlagen

### Repository
- **Repo:** https://github.com/openclaw/openclaw
- **GitHub Issues/PRs:** Verwende `-F - <<'EOF'` für multiline Strings in Kommentaren

### Projektstruktur

```
src/                           # Quellcode
├── cli/                        # CLI-Verkabelung
├── commands/                   # Befehle
├── provider-web.ts            # Web-Provider
├── infra/                     # Infrastruktur
├── media/                     # Media-Pipeline
├── telegram/                  # Telegram-Channel
├── discord/                   # Discord-Channel
├── slack/                    # Slack-Channel
├── signal/                   # Signal-Channel
├── imessage/                 # iMessage-Channel
├── web/                      # WhatsApp Web
├── channels/                 # Channel-Routing
└── routing/                  # Routing-Logik
```

```
tests/                         # Tests (colocated *.test.ts)
docs/                         # Dokumentation (Mintlify)
extensions/                   # Plugins/Extensions (Workspace-Pakete)
skills/                       # Agent-Skills
```

## Coding-Stil & Namenskonventionen

### Sprache & Formatierung
- **Sprache:** TypeScript (ESM)
- **Striktes Typing:** `any` vermeiden
- **Linting/Formatting:** Oxlint und Oxfmt ( `pnpm check` )
- **Vor Commits ausführen:** `pnpm check`

### Dateigröße & Struktur
- **Ziel:** Dateien unter ~700 LOC halten
- **Refactoring:** Helpers extrahieren statt "V2"-Kopien
- **CLI-Optionen:** Bestehende Muster verwenden
- **Dependency Injection:** `createDefaultDeps` nutzen

### Naming
- **Produkt/App/Docs:** **OpenClaw**
- **CLI/Binary/Pfad/Config:** `openclaw`

### Kommentare
- Kurze Code-Kommentare für trickige oder nicht offensichtliche Logik hinzufügen

## Build, Test & Development

### Basis
- **Node:** 22+ (Node + Bun Pfade funktionierend halten)

### Installation
```bash
pnpm install
```

### Pre-Commit Hooks
```bash
prek install
```

### Alternative: Bun
```bash
bun install
```

### CLI im Dev-Modus ausführen
```bash
pnpm openclaw ...
# oder
pnpm dev
```

### TypeScript ausführen (Bun bevorzugt)
```bash
bun <file.ts>
bunx <tool>
```

### Build & Type-Check
```bash
pnpm build
pnpm tsgo
```

### Lint & Format
```bash
pnpm check
```

### Tests (Vitest)
```bash
pnpm test
# mit Coverage
pnpm test:coverage
```

### Live-Tests (echte Keys)
```bash
# OpenClaw-only
CLAWDBOT_LIVE_TEST=1 pnpm test:live
# inkl. Provider
LIVE=1 pnpm test:live
```

## Release Channels

| Channel | Beschreibung |
|---------|-------------|
| `stable` | Getaggte Releases (z.B. `vYYYY.M.D`), npm dist-tag `latest` |
| `beta` | Prerelease Tags (z.B. `vYYYY.M.D-beta.N`), npm dist-tag `beta` |
| `dev` | Moving Head auf `main` (kein Tag) |

## Commit & Pull Request Guidelines

### Commit erstellen
```bash
scripts/committer "<msg>" <file...>
```
→ Manuelles `git add`/`git commit` vermeiden

### Commit-Message-Stil
Konkret und action-orientiert:
- `CLI: add verbose flag to send`
- `fix: resolve merge conflict in config`

### Änderungen gruppieren
- Unzusammenhängende Refactors nicht bündeln

### PR-Workflow

#### Review-Modus (nur PR-Link)
- `gh pr view/diff` lesen
- **NICHT** branches wechseln
- **NICHT** Code ändern

#### Landing-Modus
1. Integration-Branch von `main` erstellen
2. PR-Commits einbringen (**Rebase bevorzugt**, Merge erlaubt)
3. Fixes anwenden
4. Changelog-Eintrag hinzufügen (+ Thanks + PR #)
5. Vollständigen Gate lokal ausführen: `pnpm build && pnpm check && pnpm test`
6. Committen
7. Auf `main` mergen
8. Temp-Branch löschen

### Neue Contributors
- Nach Merge: Avatar zu README "Thanks to all clawtributors" hinzufügen
- Script: `bun scripts/update-clawtributors.ts`

## Testing Guidelines

### Framework
- **Vitest** mit V8 Coverage Thresholds
- **Ziele:** 70% lines/branches/functions/statements

### Namenskonvention
- Source-Name mit `*.test.ts` matchen
- E2E: `*.e2e.test.ts`

### Test-Worker
- Nicht über 16 setzen (schon probiert)

### Tests ausführen
```bash
pnpm test
pnpm test:coverage
```

### Mobile Tests
- Vor Simulator: Echte verbundene Geräte prüfen (iOS + Android)
- Echte Geräte bevorzugen

## macOS-spezifisch

### Gateway Neustart
```bash
# Über OpenClaw Mac App oder
./scripts/restart-mac.sh
```

### Prozesse verifizieren/killen
```bash
launchctl print gui/$UID | grep openclaw
```

### Logs abfragen
```bash
./scripts/clawlog.sh
```

### macOS App Build (dev)
```bash
scripts/package-mac-app.sh
# Default: aktuelle Architektur
```

## Versionsverwaltung

| Bereich | Datei |
|---------|-------|
| CLI | `package.json` |
| Android | `apps/android/app/build.gradle.kts` |
| iOS | `apps/ios/Sources/Info.plist` + `apps/ios/Tests/Info.plist` |
| macOS | `apps/macos/Sources/OpenClaw/Resources/Info.plist` |
| Mintlify Docs | `docs/install/updating.md` |
| Mac Release | `docs/platforms/mac/release.md` |

## Plugins/Extensions

### Installation
- `npm install --omit=dev` im Plugin-Verzeichnis
- Runtime-Deps: `dependencies`
- `workspace:*` in `dependencies` vermeiden (npm install bricht)
- `openclaw` in `devDependencies` oder `peerDependencies`

### Pfad
- `extensions/*`

## Routing & Channels

**Immer** alle Built-in + Extension-Channels bei Refactoring berücksichtigen:

| Built-in Channels | Code |
|-------------------|------|
| Telegram | `src/telegram` |
| Discord | `src/discord` |
| Slack | `src/slack` |
| Signal | `src/signal` |
| iMessage | `src/imessage` |
| WhatsApp Web | `src/web` |
| Core | `src/channels`, `src/routing` |

| Extensions | Pfad |
|-----------|------|
| MS Teams | `extensions/msteams` |
| Matrix | `extensions/matrix` |
| Zalo | `extensions/zalo` |
| Voice Call | `extensions/voice-call` |

## Docs

### Mintlify (docs.openclaw.ai)
- **Interne Links:** `/pfad/ohne/.md` (root-relative)
- **Section Cross-References:** Anchors auf root-relative Pfade
- **Headings:** Em-Dashes und Apostrophe vermeiden

### GitHub README
- Absolute Docs-URLs verwenden (`https://docs.openclaw.ai/...`)

### Platzhalter
- Keine echten Gerätenamen/Hostnames/Pfade
- Platzhalter: `user@gateway-host`

### Changelog
- Neueste released Version oben (kein `Unreleased`)
- Nach Publish: Version bumpen und neue Sektion erstellen

## Security

- **Web-Provider Creds:** `~/.openclaw/credentials/`
- **Pi Sessions:** `~/.openclaw/sessions/` (nicht konfigurierbar)
- **Env-Vars:** `~/.profile`

### WICHTIG
- **Niemals** echte Telefonnummern, Videos oder Live-Config-Werte committen
- Offensichtliche Fake-Platzhalter in Docs, Tests, Examples verwenden

## exe.dev VM Operations

### SSH
```bash
ssh exe.dev
ssh vm-name
```

### Update
```bash
sudo npm i -g openclaw@latest
```

### Config
```bash
openclaw config set ...
# gateway.mode=local sicherstellen
```

### Discord Token
- **Nur** rohen Token speichern (kein `DISCORD_BOT_TOKEN=` Prefix)

### Restart Gateway
```bash
pkill -9 -f openclaw-gateway || true
nohup openclaw gateway run --bind loopback --port 18789 --force > /tmp/openclaw-gateway.log 2>&1 &
```

### Verify
```bash
openclaw channels status --probe
ss -ltnp | rg 18789
tail -n 120 /tmp/openclaw-gateway.log
```

## Troubleshooting

### Rebrand/Migration/Legacy
```bash
openclaw doctor
```

### Signal Update
```bash
fly ssh console -a flawd-bot -C "bash -lc 'cd /data/clawd/openclaw && git pull --rebase origin main'"
```
Dann:
```bash
fly machines restart e825232f34d058 -a flawd-bot
```

## CLI Progress & Status

- **Progress:** `src/cli/progress.ts` (`osc-progress` + `@clack/prompts` spinner)
- **Status:** `src/terminal/table.ts` (ANSI-safe wrapping)
  - `status --all` = read-only/pasteable
  - `status --deep` = probes

## A2UI Bundle

- Hash: `src/canvas-host/a2ui/.bundle.hash` (auto-generiert)
- Ignorieren bei unerwarteten Änderungen
- Regenerieren: `pnpm canvas:a2ui:bundle` oder `scripts/bundle-a2ui.sh`
- Hash als separaten Commit committen

## Release Signing/Notary Keys

- Außerhalb des Repos verwaltet
- Interne Release-Docs folgen

## Auth Env Vars (für Notarization)
```bash
APP_STORE_CONNECT_ISSUER_ID
APP_STORE_CONNECT_KEY_ID
APP_STORE_CONNECT_API_KEY_P8
```

## Befehlsübersicht (Shorthand)

### Sync (wenn Working Tree dirty)
```bash
# Alle Änderungen committen (sinnvolle Commit-Message)
# Dann
git pull --rebase
```

## Multi-Agent Safety

- **NICHT** `git stash` erstellen/anwenden/droppen (除非 explizit angefordert)
- Andere Agents könnten arbeiten
- Unrelated WIP nicht ändern

- **NICHT** `git worktree` checkouts erstellen/entfernen/modifizieren
- **NICHT** branches wechseln

- **OK:** Mehrere Agents, jeder mit eigener Session

- Bei unrecognized Files: Weiter machen, Fokus auf eigene Änderungen

## Lint/Format-Änderungen

- Wenn staged+unstaged diffs nur Formatierung: Auto-Resolve ohne zu fragen
- Wenn Commit/Push schon angefordert: Auto-staging, Formatierung in gleichen Commit
- Nur fragen bei semantischen Änderungen (Logik/Daten/Behavior)

## GitHub Issue oder PR gegeben

- URL am Ende der Aufgabe drucken

## Antworten

- Nur High-Confidence-Antworten: Im Code verifizieren, nicht raten

## Carbon Dependency

- **NIE** die Carbon Dependency aktualisieren

## Patches

- `pnpm.patchedDependencies` muss exakte Version verwenden (kein `^`/`~`)

## Weitere Infos

### Tool Schema Guardrails (google-antigravity)
- `Type.Union` in Tool-Input-Schemes vermeiden
- Keine `anyOf`/`oneOf`/`allOf`
- `stringEnum`/`optionalStringEnum` für String-Listen
- `Type.Optional(...)` statt `... | null`
- Top-level Tool-Schema: `type: "object"` mit `properties`

### Format Property
- `format` Property Namen in Tool-Schemes vermeiden (einige Validatoren lehnen ab)

### Voice Wake Forwarding
- Command-Template: `openclaw-mac agent --message "${text}" --thinking low`
- `VoiceWakeForwarder` escaped `${text}` schon
- **NICHT** extra Quotes hinzufügen

### launchd PATH
- launchd PATH ist minimal
- App's launch agent PATH muss Standard-Pfade + pnpm bin enthalten (typisch `$HOME/Library/pnpm`)
- `pnpm`/`openclaw` Binary resolve im launchd Context

### Manual `openclaw message send` mit `!`
- Heredoc Pattern verwenden (siehe unten)

## Heredoc Pattern für Messages mit `!`

```bash
openclaw message send --channel telegram --session-id XYZ --text "$(cat <<'EOF'
Deine Message hier mit ! und speziellen Zeichen
EOF
)"
```

## Versions-Locations (Schnellreferenz)

| Bereich | Location |
|---------|----------|
| CLI | `package.json` |
| Android | `apps/android/app/build.gradle.kts` |
| iOS | `apps/ios/Sources/Info.plist` |
| macOS | `apps/macos/Sources/OpenClaw/Resources/Info.plist` |
| Docs Update Version | `docs/install/updating.md` |
| Mac Release | `docs/platforms/mac/release.md` |

## NPM + 1Password (Publish/Verify)

### Sign In
```bash
eval "$(op signin --account my.1password.com)"
```

### OTP
```bash
op read 'op://Private/Npmjs/one-time password?attribute=otp'
```

### Publish
```bash
npm publish --access public --otp="<otp>"
```

### Verify ohne lokale npmrc
```bash
npm view <pkg> version --userconfig "$(mktemp)"
```

---

## Workflow-Referenzen

Für detaillierte Workflows, diese Dateien konsultieren:

1. **PR Review:** `.openclaw/prompts/workflows/pr-review.md`
2. **PR Prepare:** `.openclaw/prompts/workflows/pr-prepare.md`
3. **PR Merge:** `.openclaw/prompts/workflows/pr-merge.md`
4. **Upstream Sync:** `.openclaw/prompts/workflows/update-clawdbot.md`

---

## Skills-Referenzen

Für domänenspezifische Prompts:

1. **Coding Agent:** `.openclaw/prompts/skills/coding-agent.md`
2. **GitHub:** `.openclaw/prompts/skills/github.md`
3. **Skill Creator:** `.openclaw/prompts/skills/skill-creator.md`
4. **Discord/Slack/Voice-Call:** `.openclaw/prompts/skills/`

---

**Ende des Master-Prompts
