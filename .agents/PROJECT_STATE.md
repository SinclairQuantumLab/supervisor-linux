# .agents/PROJECT_STATE.md

## Repository snapshot

- Repository purpose: document and support usage of `supervisor` on Linux.
- Split status: completed from the old mixed `supervisor-setting` layout and recorded by Linux split commit `ce1631d`.
- GitHub remote: `origin = https://github.com/SinclairQuantumLab/supervisor-linux.git`.
- Intended deployment checkout: `~/Projects/supervisor`, despite the GitHub repository name `supervisor-linux`.
- Primary implementation: the root `uv` project, root configuration templates, `supervisor.service.template`, `python/` app helpers, and the opt-in child test under `tests/`.
- Primary runtime flow: user `supervisor.service` -> `.venv/bin/supervisord -n -c <SUPERVISOR_DIR>/supervisord.conf` -> `conf.d/*.conf`, as introduced in `2a0183b`.
- Primary CLI setup: `~/.local/bin/supervisorctl` -> symlinked `.venv/bin/supervisorctl`. Config discovery outside the repository is not yet resolved; the new test walkthrough keeps the CLI terminal in the repo root.
- The root unit is copied to ignored `supervisor.service` and linked into `~/.config/systemd/user/`. Older system-service helpers and alternate README sections remain tracked but are not the primary setup.
- The inherited `linux/` tree remains tracked as legacy reference material and is not the normal installation source.
- Repository-level agent instructions use the standard root `AGENTS.md`; handoff documents live under `.agents/`.
- Windows parity comparison and paired edits use the sibling checkout at `C:\Users\Joon\Projects\supervisor` directly; no Windows checkout is embedded in this repository.

## Current phase

- Post-split parity development started on 2026-07-18.
- Common layout, configuration policy, usage concepts, code comments, and README style now follow the current Windows implementation except where Linux and systemd require different behavior.
- Linux keeps its native split between a user-only Unix socket for `supervisorctl` and an authenticated loopback TCP endpoint for the Web UI.
- The GUI/logging probe mirrors the Windows sibling's current Python test byte-for-byte. Only the test config paths, interpreter, and README shell/authentication/display details differ; the app is opt-in and does not restart itself.
- The README mirrors Windows `3ae01c7`: common update/start/removal instructions live in `Adding an app`, and the compact child-test section refers to those steps.
- The root parity implementation is the active model; materialized config, logs, PID/socket files, virtual environments, and caches remain local and ignored.
- Static configuration, lock, shell, and repository checks passed on the Windows development host on 2026-07-18. A real Linux systemd end-to-end test is still required before the runtime should be considered operationally proven.

## Known cautions

- Do not use or rewrite the legacy `linux/` files as if they were the canonical root model.
- Keep Git status, staging, commits, and destructive operations separate between this repository and `C:\Users\Joon\Projects\supervisor`.
- A materialized `supervisord.conf` contains credentials and must remain untracked.
- Linux `main` at `931f993` still has older installation/usage inconsistencies: the password substitution targets `supervisor.service` instead of `supervisord.conf`, the user unit names `default-user.target` instead of the standard `default.target`, and other sections retain system-service commands, `/etc/supervisor` paths, and the removed `supervisorctl.sh`. This test-app change does not correct those unrelated workflows.
- The optional Multivisor RPC endpoint is unauthenticated and must remain limited to a trusted loopback or private network path.
- Windows-hosted static checks cannot replace validation of foreground process ownership, startup, restart, and shutdown under real Linux systemd.
- The test requires Tk in the repository's Python and access to the desktop display from the user service. Windows-hosted GUI/logging/close checks passed on 2026-09-12; Linux desktop execution remains unverified.
