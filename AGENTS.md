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
- `supervisor.service.template`: primary user-systemd unit template; the README copies it to root `supervisor.service` and links it into `~/.config/systemd/user/`.
- `Startup_supervisord.sh` and `mount-supervisord-systemd.sh`: retained older system-service helpers, not used by the current README installation flows.
- `python/Startup.sh`: Linux launcher helper copied into supervised Python projects.
- `python/supervisor/supervisor_helper.py`: shared Python logging helper.
- `tests/supervisor-test-child.py`: portable Python/tkinter GUI and stdout/stderr probe, kept byte-identical to the Windows sibling. Its opt-in `tests/supervisor-test-child.conf` uses Linux paths and the repository's `.venv/bin/python`; keep `autostart=false` and `autorestart=false`.
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
- Preserve the current installation guide's numbered-item format and user-written steps. Mirror shared additions from the current sibling working tree with only necessary OS differences; defer unrelated installation rewrites and shared improvements.
- Apply the same rule to comments: explain current behavior, safety constraints, or copy-paste flow rather than preserving implementation history.
- Prefer user-facing wording over systemd or API internals. Say what the user is doing before introducing the underlying mechanism.
- Keep high-level introductions plain and confidence-building. Put technical precision next to the exact command or setting that needs it.
- When a syntax element is likely to puzzle a user, add the smallest useful inline explanation at that exact point rather than a broad tutorial.
- The current primary Linux setup uses a user systemd service named `supervisor`, controlled by `systemctl --user`. Its root `supervisor.service.template` directly launches `.venv/bin/supervisord -n -c <SUPERVISOR_DIR>/supervisord.conf`; supervisord then loads apps from `conf.d/*.conf`.
- Keep `supervisord` in foreground mode under systemd so systemd owns its lifecycle and observes failures correctly.
- The current primary setup symlinks `.venv/bin/supervisorctl` into `~/.local/bin`; `supervisorctl.sh` was removed in `2a0183b`. Config discovery outside the repository remains a separate review item. Keep new CLI walkthroughs in the repository folder and do not redesign global CLI usage as part of unrelated mirroring work.
- `mount-supervisord-systemd.sh` should only handle systemd unit registration, enablement, and an explicitly requested immediate start. Keep dependency installation, config creation, password editing, and other setup actions as explicit README steps unless the user asks for a one-shot helper.
- Keep the current user-service setup commands explicit in the README. Quick, one-shot, and manual setup must use the same root `supervisor.service.template`, user-unit location, and `systemctl --user` commands; do not call the retained system-level helper from those flows.
- Also document the manual systemd setup path because service-manager behavior and distribution conventions may vary. Keep its displayed unit identical to the root template.
- Keep shell helpers transparent and procedural. For one-off setup steps, prefer visible variables and step-by-step flow over abstraction unless reuse or safety materially benefits from it.
- Preserve `logs/.gitignore` and `conf.d/logs/.gitignore` so required log directories exist after clone while runtime logs remain untracked.
- Keep canonical `*.sh` files on LF line endings through `.gitattributes` so Windows development does not break Bash execution.
- Keep `python/supervisor/supervisor_helper.py` aligned byte-for-byte with the Windows repository unless an OS-specific difference is genuinely required.
- Keep the child-test Python source shared unchanged across both repositories; adapt only its Supervisor config and OS-specific README commands. Linux GUI checks require Tk support and access to the logged-in desktop display; never claim Windows-hosted checks prove Linux GUI/service behavior.
- When durable project structure or workflow changes, update `AGENTS.md` and the relevant tracked `.agents/*.md` files in the same change.

## Current status

- The Linux-only split is complete and recorded in commit `ce1631d`.
- The root instruction file was renamed to the standard `AGENTS.md` in commit `f24a4d3`.
- Post-split parity development has started, using the Windows implementation as the common-behavior and writing-style baseline.
- The primary setup on `main` uses the root `uv` project and configs, a user-only Unix socket, a direct CLI executable symlink, and the explicitly registered user systemd service introduced in `2a0183b`. The README's quick, one-shot, manual, usage, and uninstall flows now consistently target that user service; older system-service helpers remain only as retained alternatives.
- The inherited `linux/` tree remains tracked only as legacy reference material.
- Windows parity work now uses the sibling repository at `C:\Users\Joon\Projects\supervisor` directly; no Windows checkout is embedded under `.agents/`.
- Durable handoff context now lives in tracked files under `.agents/`; only `.local.md` notes are ignored.
- Static configuration, lock, shell, and repository checks passed on the Windows development host on 2026-07-18. A real Linux systemd end-to-end test remains the next verification milestone.
- The Windows Python GUI/logging test was mirrored on 2026-09-12. Windows-hosted GUI checks and Linux config parsing passed; running the probe through the Linux desktop's user service remains to be verified.
