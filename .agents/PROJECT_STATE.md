# .agents/PROJECT_STATE.md

## Repository snapshot

- Repository purpose: document and support usage of `supervisor` on Linux.
- Split status: completed from the old mixed `supervisor-setting` layout and recorded by Linux split commit `ce1631d`.
- GitHub remote: `origin = https://github.com/SinclairQuantumLab/supervisor-linux.git`.
- Intended deployment checkout: `~/Projects/supervisor`, despite the GitHub repository name `supervisor-linux`.
- Primary implementation: the root `uv` project, root configuration templates, `supervisor.service.template`, `python/` app helpers, and the opt-in child test under `tests/`.
- Primary runtime flow: user `supervisor.service` -> `.venv/bin/supervisord -n -c <SUPERVISOR_DIR>/supervisord.conf` -> `conf.d/*.conf`, as introduced in `2a0183b`.
- Primary CLI setup: `~/.local/bin/supervisorctl` -> symlinked `.venv/bin/supervisorctl`. Config discovery outside the repository is not yet resolved; the README explicitly runs the CLI from the repo root.
- All README installation paths copy the root unit to ignored `supervisor.service`, link it into `~/.config/systemd/user/`, and enable it under `default.target`. No separate registration or daemon-launch helper is needed.
- The obsolete system-service helpers, inherited `linux/` reference tree, and duplicate `REAME.old.md` have been removed, matching Windows cleanup `242e267`; previous versions remain recoverable from Git history.
- Repository-level agent instructions use the standard root `AGENTS.md`; handoff documents live under `.agents/`.
- Windows parity comparison and paired edits use the sibling checkout at `C:\Users\Joon\Projects\supervisor` directly; no Windows checkout is embedded in this repository.

## Current phase

- Post-split parity development started on 2026-07-18.
- Common layout, configuration policy, usage concepts, code comments, and README style now follow the current Windows implementation except where Linux and systemd require different behavior.
- Linux keeps its native split between a user-only Unix socket for `supervisorctl` and an authenticated loopback TCP endpoint for the Web UI.
- The GUI/logging probe mirrors the Windows sibling's current Python test byte-for-byte. Only the test config paths, interpreter, and README shell/authentication/display details differ; the app is opt-in and does not restart itself.
- The README app/test sections mirror Windows `3ae01c7`: common update/start/removal instructions live in `Adding an app`, and the compact child-test section refers to those steps.
- The root parity implementation is the active model; materialized config, logs, PID/socket files, virtual environments, and caches remain local and ignored.
- Static configuration, lock, shell, and repository checks passed on the Windows development host on 2026-07-18. A real Linux systemd end-to-end test is still required before the runtime should be considered operationally proven.
- The 2026-09-12 installation corrections passed README Bash syntax, manual-unit/template equality, user-service path checks, and isolated one-shot/manual/uninstall fixture tests with simulated service-manager calls. These do not replace real Linux service validation.

## Known cautions

- Do not restore the removed legacy setup files as alternate installation paths. Preserve the current root configs, user-service template, app helpers, tests, and old-package removal instructions.
- Keep Git status, staging, commits, and destructive operations separate between this repository and `C:\Users\Joon\Projects\supervisor`.
- A materialized `supervisord.conf` contains credentials and must remain untracked.
- The installation inconsistencies identified during the `f5d8ff4` review have been corrected: password substitution targets `supervisord.conf`, the unit uses `default.target`, and normal README flows use the user service and repository paths. The manual setup's missing copy command is filled in. Keep `sudo systemctl` and `/etc/supervisor` references limited to old package-manager removal; do not reintroduce the deleted CLI wrapper or the system-level setup helper into current instructions.
- The optional Multivisor RPC endpoint is unauthenticated and must remain limited to a trusted loopback or private network path.
- Windows-hosted static checks cannot replace validation of foreground process ownership, startup, restart, and shutdown under real Linux systemd.
- The test requires Tk in the repository's Python and access to the desktop display from the user service. Windows-hosted GUI/logging/close checks passed on 2026-09-12; Linux desktop execution remains unverified.
