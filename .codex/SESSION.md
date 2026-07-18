# .codex/SESSION.md

## 2026-04-17

- Moved Linux reference material out of the old mixed `supervisor-setting` layout into `C:\Users\Joon\Projects\supervisor-linux`.
- Copied `python/Startup_bash` and `python/supervisor/supervisor_helper.py` so Linux could stand on its own as a split folder.

## 2026-04-23

- Revisited the Linux split because it lacked the same completeness as the Windows split.
- Added `README.md`, `AGENT.md`, `.gitignore`, and `.codex/` handoff files so the Linux side has reasonable symmetry with the Windows side.
- Added the trailing `Developer's note` to `README.md` so the Linux README matches the Windows-side split more closely.
- Changed the `.codex/` policy so durable project context is tracked and only `.local.md` files are ignored.
- Confirmed that `origin/main` and current history still reflect mirrored `supervisor-setting` lineage through commit `8139700`, so the Linux-only split is currently represented as worktree changes.

## 2026-07-18

- Renamed the root instruction file from `AGENT.md` to the Codex-standard `AGENTS.md` and updated active references.
- Kept handoff documents under `.codex/`; `.agents/skills/` remains available for repository-scoped skills if needed later.
