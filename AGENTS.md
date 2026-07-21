# AGENTS.md

## Purpose

- This repository documents how to use `supervisor` on Linux.
- This repository is for README, templates, helper scripts, and operational tricks around `supervisor`.
- Do not modify, vendor, or treat the upstream `supervisor` project itself as part of this repository.

## Locked project boundaries

- The original mixed repository was split on 2026-04-17, and the completed Linux split is recorded by commit `ce1631d`.
- `supervisor-linux` is the active repository for Linux-only materials.
- The GitHub repository is `https://github.com/SinclairQuantumLab/supervisor-linux`.
- The GitHub repository name is `supervisor-linux`, but the intended local deployment folder is `~/Projects/supervisor`.
- The repository root is the canonical deployment model. The older `linux/` tree remains only as inherited reference material.
- The sibling checkout at `C:\Users\Joon\Projects\supervisor` is the Windows implementation used for parity comparison and paired cross-repository edits. Work in that repository directly instead of keeping an embedded copy here.
- Common configuration, usage concepts, code comments, and document style should mirror the Windows implementation as closely as practical. Keep only genuinely OS-specific behavior Linux-native.
- Until the user explicitly asks otherwise, preserve inherited content as much as possible.
- Do not do drive-by rewrites, wording cleanup, style normalization, or template redesign unless the user asks for it.

## Current repository layout

- `README.md`: hands-on Linux setup and usage guide aligned with the Windows-side guide.
- `.python-version`, `pyproject.toml`, and `uv.lock`: the canonical root `uv` project.
- `.gitattributes`: forces canonical Bash scripts to use LF line endings on every development host.
- `supervisord.conf.template`: canonical root `supervisord` configuration template.
- `conf.d/[APPNAME].conf.template`: canonical per-app configuration template.
- `logs/.gitignore` and `conf.d/logs/.gitignore`: tracked placeholders for runtime log directories.
- `supervisorctl.sh`: symlink-aware wrapper that loads the canonical root config for plain `supervisorctl` commands from any current directory.
- `Startup_supervisord.sh`: working-directory-independent launcher used by systemd to start root-project `supervisord` in the foreground.
- `mount-supervisord-systemd.sh`: procedural helper that registers and enables the system-level `supervisor` service and can optionally start it.
- `python/Startup.sh`: Linux launcher helper copied into supervised Python projects.
- `python/supervisor/supervisor_helper.py`: shared Python logging helper.
- `linux/`: inherited pre-parity `/etc`-style templates retained for reference, not the canonical installation path.

## Context handoff policy

- `AGENTS.md` is the durable, tracked source of truth for repo purpose, boundaries, and workflow rules.
- `.agents/PROJECT_STATE.md` is the durable, tracked snapshot of current repository state, important cautions, and active phase.
- `.agents/DECISIONS.md` is the durable, tracked record of locked decisions and non-obvious constraints.
- `.agents/SESSION.md` is the durable, tracked milestone log for major repository events.
- `.agents/NEXT-STEPS.md` is the durable, tracked resumption checklist and next-action queue.
- `.agents/*.local.md` is reserved for machine-specific, worktree-specific, or thread-specific notes that should not be committed.
- Durable handoff context should live in tracked `.agents/*.md` files; only true local notes should be ignored.
- Reserve `.agents/skills/` for repository-scoped agent skills if they are added later. Do not place comparison-repository checkouts under `.agents/`.

## Required agent workflow

- At the start of work, read `AGENTS.md` first.
- Then read `.agents/PROJECT_STATE.md`, `.agents/DECISIONS.md`, `.agents/SESSION.md`, and `.agents/NEXT-STEPS.md`.
- If relevant local notes exist, read `.agents/*.local.md` before making new assumptions.
- When durable repo state or decisions change, update the tracked `.agents/*.md` files before finishing.
- When temporary machine/worktree/thread context matters, write it under `.agents/*.local.md`.
- Keep `AGENTS.md` stable. Update it only for durable rules, durable structure changes, or durable project-state milestones.

## Working rules

- Treat this repository as a usage/support repository for `supervisor`, not as the upstream project.
- Prefer minimal, explicit edits over broad cleanup.
- Treat the root `uv` project and root configuration templates as canonical. Do not redirect normal users to the legacy `linux/` tree.
- For Windows parity work, inspect or edit `C:\Users\Joon\Projects\supervisor` directly as the task requires. Keep its Git status, commits, and staging separate from this Linux repository.
- `README.md` is for hands-on introduction, setup instructions, usage guidance, and other content that helps a normal user apply this repository immediately.
- Do not use `README.md` for issue history, debugging history, or reassurance aimed at maintainers. If a rare developer-facing note truly belongs, keep it in a `Developer's note` section at the bottom.
- Apply the same rule to comments: explain current behavior, safety constraints, or copy-paste flow rather than preserving implementation history.
- Prefer user-facing wording over systemd or API internals. Say what the user is doing before introducing the underlying mechanism.
- Keep high-level introductions plain and confidence-building. Put technical precision next to the exact command or setting that needs it.
- When a syntax element is likely to puzzle a user, add the smallest useful inline explanation at that exact point rather than a broad tutorial.
- The preferred Linux runtime model is a system-level systemd service named `supervisor` that runs as the configured non-root user. It launches `Startup_supervisord.sh`, which runs `.venv/bin/supervisord -n -c ./supervisord.conf`; supervisord then loads apps from `conf.d/*.conf`.
- Keep `supervisord` in foreground mode under systemd so systemd owns its lifecycle and observes failures correctly.
- The preferred global command is `supervisorctl`, made available by symlinking the root project's `supervisorctl.sh` into `~/.local/bin`. The wrapper must resolve its real repository path and invoke `.venv/bin/supervisorctl -c <REPO_ROOT>/supervisord.conf` so the Linux Unix-socket configuration works from any current directory. Do not invent a differently named user-facing command.
- `mount-supervisord-systemd.sh` should only handle systemd unit registration, enablement, and an explicitly requested immediate start. Keep dependency installation, config creation, password editing, and other setup actions as explicit README steps unless the user asks for a one-shot helper.
- Keep detailed systemd shell code in the helper and keep README commands short enough to copy and run.
- Also document the manual systemd setup path because service-manager behavior and distribution conventions may vary.
- Keep shell helpers transparent and procedural. For one-off setup steps, prefer visible variables and step-by-step flow over abstraction unless reuse or safety materially benefits from it.
- Preserve `logs/.gitignore` and `conf.d/logs/.gitignore` so required log directories exist after clone while runtime logs remain untracked.
- Keep canonical `*.sh` files on LF line endings through `.gitattributes` so Windows development does not break Bash execution.
- Keep `python/supervisor/supervisor_helper.py` aligned byte-for-byte with the Windows repository unless an OS-specific difference is genuinely required.
- When durable project structure or workflow changes, update `AGENTS.md` and the relevant tracked `.agents/*.md` files in the same change.

## Current status

- The Linux-only split is complete and recorded in commit `ce1631d`.
- The root instruction file was renamed to the standard `AGENTS.md` in commit `f24a4d3`.
- Post-split parity development has started, using the Windows implementation as the common-behavior and writing-style baseline.
- The canonical Linux model now uses the root `uv` project, relative root configuration, a user-only Unix socket for the CLI, `supervisorctl.sh`, `Startup_supervisord.sh`, and a non-root systemd service registered by `mount-supervisord-systemd.sh`.
- The inherited `linux/` tree remains tracked only as legacy reference material.
- Windows parity work now uses the sibling repository at `C:\Users\Joon\Projects\supervisor` directly; no Windows checkout is embedded under `.agents/`.
- Durable handoff context now lives in tracked files under `.agents/`; only `.local.md` notes are ignored.
- Static configuration, lock, shell, and repository checks passed on the Windows development host on 2026-07-18. A real Linux systemd end-to-end test remains the next verification milestone.
