# .codex/PROJECT_STATE.md

## Repository snapshot

- Repository purpose: document and support usage of `supervisor` on Linux.
- Split status: completed on 2026-04-17 from the old mixed `supervisor-setting` layout.
- Active tracked files center on `README.md`, `linux/`, and `python/`.
- GitHub remote: `origin = https://github.com/SinclairQuantumLab/supervisor-linux.git`.

## Current phase

- Linux split documentation is in place.
- The Linux-only split has not yet been recorded as its own commit on top of the imported history.

## Known cautions

- `README.md` preserves inherited wording where possible; some inherited factual inconsistencies may still exist.
- Do not silently "improve" or modernize inherited content unless the user explicitly asks.
- Because the repository history still reflects mirrored pre-split contents, `git status` will show the Linux split as worktree changes until a dedicated Linux split commit is made.
