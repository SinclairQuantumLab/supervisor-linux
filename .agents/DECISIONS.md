# .agents/DECISIONS.md

## Locked decisions

- This repository must not modify the upstream `supervisor` project.
- The Linux split is complete and recorded by commit `ce1631d`; do not describe it as uncommitted split work.
- The Windows repository is the parity baseline for common layout, configuration semantics, usage concepts, code comments, and document style. Linux and systemd behavior remains Linux-native.
- The canonical installation source is the repository root. The inherited `linux/` tree is retained only as legacy reference material.
- The intended deployment checkout is `~/Projects/supervisor`.
- The root project is managed with `uv`; virtual environments are recreated locally and never copied from another checkout.
- The preferred runtime is a system-level systemd service named `supervisor` running as the configured non-root user.
- systemd launches `Startup_supervisord.sh`, which keeps supervisord in foreground mode with `.venv/bin/supervisord -n -c ./supervisord.conf`.
- `mount-supervisord-systemd.sh` generates, registers, and enables `/etc/systemd/system/supervisor.service`, and starts it only when `--run-now` is explicitly passed. It does not install dependencies, create `supervisord.conf`, or edit credentials.
- The README must retain an explicit manual systemd setup path in addition to the registration helper.
- The preferred global CLI is `~/.local/bin/supervisorctl`, symlinked to the root project's `supervisorctl.sh`. The wrapper resolves the real repository path and passes the canonical root config to `.venv/bin/supervisorctl`, so plain CLI commands use the correct endpoint from any current directory.
- Linux `supervisorctl` connects through a `0700` Unix socket at `%(here)s/supervisor.sock` without application-level credentials. The loopback `[inet_http_server]` remains separately authenticated for the Web UI.
- Root main and app configs use relative paths and keep the Windows-side log rotation and restart policy unless Linux requires a documented difference.
- The systemd unit uses `KillMode=mixed` so supervisord receives the normal termination signal and can stop its children before systemd cleans up any processes left at timeout.
- The optional Multivisor RPC interface must bind only to a trusted loopback or private interface and must not be exposed to an untrusted network.
- Canonical Bash scripts are forced to LF line endings through `.gitattributes`.
- Materialized configs, credentials, logs, PID/socket files, history, virtual environments, and caches are runtime state and remain untracked.
- Use `C:\Users\Joon\Projects\supervisor` directly for Windows parity comparison and paired cross-repository edits. Do not keep a Windows checkout under this repository's `.agents/` directory.
- `python/supervisor/supervisor_helper.py` should stay byte-identical to the Windows copy unless an OS-specific change is explicitly justified.
- Development context should be durable and repo-portable by default: tracked context goes in `.agents/*.md`, while true local-only notes go in `.agents/*.local.md`.
- Repository instructions use the Codex-standard root filename `AGENTS.md` so they are discovered automatically.
- Keep handoff documents under `.agents/`; `.agents/skills/` remains reserved for repository-scoped skills.

## History-sensitive constraints

- Commit `ce1631d` records the completed Linux-only split on top of the imported `supervisor-setting` lineage.
- Commit `f24a4d3` records the later rename from `AGENT.md` to the standard `AGENTS.md`; preserve that history.
- The initial parity review inspected the Windows implementation at commit `abef226`. Future comparisons must inspect the current state of the sibling Windows repository directly instead of relying on that historical snapshot.
- Before rebasing, resetting, force-pushing, or broadly staging, inspect local `main`, `origin/main`, and the worktree state separately in both repositories.
