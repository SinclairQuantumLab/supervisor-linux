# .agents/DECISIONS.md

## Locked decisions

- This repository must not modify the upstream `supervisor` project.
- The Linux split is complete and recorded by commit `ce1631d`; do not describe it as uncommitted split work.
- The Windows repository is the parity baseline for common layout, configuration semantics, usage concepts, code comments, and document style. Linux and systemd behavior remains Linux-native.
- The canonical installation source is the repository root. The superseded `linux/` tree, system-service helpers, and duplicate old README are preserved only in Git history, not in the current checkout.
- The intended deployment checkout is `~/Projects/supervisor`.
- The root project is managed with `uv`; virtual environments are recreated locally and never copied from another checkout.
- The primary runtime since `2a0183b` is a user systemd service named `supervisor`, registered from root `supervisor.service.template` and controlled with `systemctl --user`.
- The primary unit directly launches `.venv/bin/supervisord -n -c <SUPERVISOR_DIR>/supervisord.conf`. The materialized main config remains in the repository.
- The README's quick, one-shot, and manual setup paths all register the same root user-service template under `~/.config/systemd/user/` with `WantedBy=default.target`. Keep registration commands visible in the README rather than restoring the removed system-level registration and daemon-launch helpers.
- The primary guide now symlinks `.venv/bin/supervisorctl` directly; the wrapper was removed in `2a0183b`. Keep long-term CLI/config-discovery choices separate from the child-test port and do not promise arbitrary-working-directory discovery.
- Linux `supervisorctl` connects through a `0700` Unix socket at `%(here)s/supervisor.sock` without application-level credentials. The loopback `[inet_http_server]` remains separately authenticated for the Web UI.
- Root main and app configs use relative paths and keep the Windows-side log rotation and restart policy unless Linux requires a documented difference.
- The systemd unit uses `KillMode=mixed` so supervisord receives the normal termination signal and can stop its children before systemd cleans up any processes left at timeout.
- Preserve the optional Multivisor example with `bind=*:9002` and the user-approved `(<LISTENING_IP>:<PORT>)` inline comment, as explicitly requested on 2026-11-06. Do not replace it with a restricted-interface placeholder unless the user requests that change.
- Canonical Bash scripts are forced to LF line endings through `.gitattributes`.
- Materialized configs, credentials, logs, PID/socket files, history, virtual environments, and caches are runtime state and remain untracked.
- Use `C:\Users\Joon\Projects\supervisor` directly for Windows parity comparison and paired cross-repository edits. Do not keep a Windows checkout under this repository's `.agents/` directory.
- `python/supervisor/supervisor_helper.py` should stay byte-identical to the Windows copy unless an OS-specific change is explicitly justified.
- `tests/supervisor-test-child.py` stays byte-identical to the Windows copy. Its Linux config uses `.venv/bin/python` and the existing `ENV_HOME` convention, with `autostart=false`, `startretries=0`, and `autorestart=false`, matching Windows's opt-in test policy.
- Preserve numbered installation items and minimal OS adaptations. Shared README improvements and unrelated installation corrections require their own task rather than being folded into a test-app mirror.
- Development context should be durable and repo-portable by default: tracked context goes in `.agents/*.md`, while true local-only notes go in `.agents/*.local.md`.
- Repository instructions use the Codex-standard root filename `AGENTS.md` so they are discovered automatically.
- Keep handoff documents under `.agents/`; `.agents/skills/` remains reserved for repository-scoped skills.

## History-sensitive constraints

- Commit `ce1631d` records the completed Linux-only split on top of the imported `supervisor-setting` lineage.
- Commit `f24a4d3` records the later rename from `AGENT.md` to the standard `AGENTS.md`; preserve that history.
- The initial parity review inspected the Windows implementation at commit `abef226`. Future comparisons must inspect the current state of the sibling Windows repository directly instead of relying on that historical snapshot.
- Before rebasing, resetting, force-pushing, or broadly staging, inspect local `main`, `origin/main`, and the worktree state separately in both repositories.
