---
name: sync-claude
description: Publish this machine's setup changes and pull everyone else's — runs the repo's sync.sh.
disable-model-invocation: true
---

# Sync the setup repo

Publishing is user-triggered (the repo's ADR-0002): this invocation is
the one sanctioned path to `sync.sh`. Outside it, leave repo changes
uncommitted and point the user here.

The dotfiles are symlinked from the repo, so the repo root can always be
found from the `CLAUDE.md` link:

```bash
REPO="$(dirname "$(readlink "$HOME/.claude/CLAUDE.md")")/.."
bash "$REPO/sync.sh" "<commit message>"
```

Steps:

1. Commit message: pass the user's words through (`/sync-claude added
   pdf skill`); given none, summarize `git -C "$REPO" status --short`
   in a few words yourself.
2. Run it and show the user the real output.
3. A stopped gate stays stopped — explain the fix instead:
   - **"not linked"** → the machine needs `./install.sh` first.
   - **"possible secret"** → move the flagged content to a per-machine
     env var; suggest `SKIP_SECRET_SCAN=1` only after the user confirms
     a false positive.

Done when the output ends in `✔ pushed` (or `nothing new to commit`),
or a gate's fix is in the user's hands.
