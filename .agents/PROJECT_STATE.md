# .agents/PROJECT_STATE.md

## Repository snapshot

- Repository purpose: document and support usage of `supervisor` on Linux.
- Split status: completed from the old mixed `supervisor-setting` layout and recorded by Linux split commit `ce1631d`.
- GitHub remote: `origin = https://github.com/SinclairQuantumLab/supervisor-linux.git`.
- Intended deployment checkout: `~/Projects/supervisor`, despite the GitHub repository name `supervisor-linux`.
- Canonical implementation: the root `uv` project, root configuration templates, the `supervisorctl.sh` CLI wrapper, root launch and systemd-registration helpers, and `python/` app helpers.
- Canonical runtime flow: system-level `supervisor.service` as a configured non-root user -> `Startup_supervisord.sh` -> `.venv/bin/supervisord -n -c ./supervisord.conf` -> `conf.d/*.conf`.
- Canonical CLI flow: `~/.local/bin/supervisorctl` -> symlinked root `supervisorctl.sh` -> `.venv/bin/supervisorctl -c <REPO_ROOT>/supervisord.conf` -> the root config's user-only Unix socket.
- `mount-supervisord-systemd.sh` generates, registers, and enables `/etc/systemd/system/supervisor.service`, with optional immediate start; there is no canonical root service-template file.
- The inherited `linux/` tree remains tracked as legacy reference material and is not the normal installation source.
- Repository-level agent instructions use the standard root `AGENTS.md`; handoff documents live under `.agents/`.
- Windows parity comparison and paired edits use the sibling checkout at `C:\Users\Joon\Projects\supervisor` directly; no Windows checkout is embedded in this repository.

## Current phase

- Post-split parity development started on 2026-07-18.
- Common layout, configuration policy, usage concepts, code comments, and README style now follow the current Windows implementation except where Linux and systemd require different behavior.
- Linux keeps its native split between a user-only Unix socket for `supervisorctl` and an authenticated loopback TCP endpoint for the Web UI.
- The root parity implementation is the active model; materialized config, logs, PID/socket files, virtual environments, and caches remain local and ignored.
- Static configuration, lock, shell, and repository checks passed on the Windows development host on 2026-07-18. A real Linux systemd end-to-end test is still required before the runtime should be considered operationally proven.

## Known cautions

- Do not use or rewrite the legacy `linux/` files as if they were the canonical root model.
- Keep Git status, staging, commits, and destructive operations separate between this repository and `C:\Users\Joon\Projects\supervisor`.
- A materialized `supervisord.conf` contains credentials and must remain untracked.
- The systemd helper requires elevated privileges to register the unit, but the service itself must run supervisord as the configured non-root user.
- The optional Multivisor RPC endpoint is unauthenticated and must remain limited to a trusted loopback or private network path.
- Windows-hosted static checks cannot replace validation of foreground process ownership, startup, restart, and shutdown under real Linux systemd.
