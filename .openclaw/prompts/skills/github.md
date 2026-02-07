# GitHub Skill

Verwende die `gh` CLI um mit GitHub zu interagieren.

## Pull Requests

### Check CI status on a PR

```bash
gh pr checks 55 --repo owner/repo
```

### List recent workflow runs

```bash
gh run list --repo owner/repo --limit 10
```

### View a run and see which steps failed

```bash
gh run view <run-id> --repo owner/repo
```

### View logs for failed steps only

```bash
gh run view <run-id> --repo owner/repo --log-failed
```

## API for Advanced Queries

Get PR with specific fields:

```bash
gh api repos/owner/repo/pulls/55 --jq '.title, .state, .user.login'
```

## JSON Output

Most commands support `--json` for structured output:

```bash
gh issue list --repo owner/repo --json number,title --jq '.[] | "\(.number): \(.title)"'
```

## Always specify repo

Always specify `--repo owner/repo` when not in a git directory, or use URLs directly.
