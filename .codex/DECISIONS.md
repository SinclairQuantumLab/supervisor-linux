# .codex/DECISIONS.md

## Locked decisions

- This repository must not modify the upstream `supervisor` project.
- The split phase allowed only extraction and minimum context repair.
- Windows material lives in `C:\Users\Joon\Projects\supervisor-windows` as the sibling split.
- Until the user explicitly asks otherwise, preserve inherited content as much as possible.
- Development context should be durable and repo-portable by default: tracked context goes in `.codex/*.md`, while true local-only notes go in `.codex/*.local.md`.
- Repository instructions use the Codex-standard root filename `AGENTS.md` so they are discovered automatically.
- Keep handoff documents under `.codex/`; reserve `.agents/skills/` for repository-scoped skills rather than treating `.agents/` as the companion directory for `AGENTS.md`.

## History-sensitive constraints

- The GitHub repo is connected to mirrored `supervisor-setting` lineage, currently visible at `origin/main` through commit `8139700`.
- Before rebasing, resetting, or force-pushing, inspect the relationship between local `main`, `origin/main`, and the current Linux-only worktree changes.
