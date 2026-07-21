# .agents/SESSION.md

## 2026-04-17

- Split Linux reference material out of the old mixed `supervisor-setting` layout into `C:\Users\Joon\Projects\supervisor-linux`.
- Kept the Linux templates and Python helpers so the Linux side could stand on its own.

## 2026-04-23

- Recorded the completed Linux-only split in commit `ce1631d` on top of the imported history.
- Revisited the Linux repository because it lacked the same completeness as the Windows split.
- Added `README.md`, `AGENT.md`, `.gitignore`, and `.codex/` handoff files so the Linux side has reasonable symmetry with the Windows side.
- Added the trailing `Developer's note` to `README.md` so the Linux README matches the Windows-side split more closely.
- Changed the `.codex/` policy so durable project context is tracked and only `.local.md` files are ignored.

## 2026-07-18

- Renamed the root instruction file from `AGENT.md` to the Codex-standard `AGENTS.md` and updated active references.
- Kept handoff documents under `.codex/`; `.agents/skills/` remains available for repository-scoped skills if needed later.
- Inspected the embedded Windows checkout at baseline `abef226` and separated its active root implementation from legacy, runtime, and accidental files.
- Started real post-split parity development, using the Windows repository as the baseline for common configuration, usage concepts, code comments, and document style.
- Established the canonical Linux root model: root `uv` metadata and configs, `Startup_supervisord.sh`, `mount-supervisord-systemd.sh`, root log placeholders, and `python/Startup.sh`.
- Selected a system-level `supervisor` unit that runs as a configured non-root user and keeps supervisord in foreground mode under systemd.
- Kept dependency installation, config creation, password editing, and manual systemd setup as explicit README steps; the mount helper is limited to unit registration, enablement, and an optional explicit start.
- Retained `linux/` as legacy reference material while removing it from the normal installation path.
- Marked `.agents/supervisor-windows/` as an ignored, read-only local reference that must never be committed.
- Preserved byte parity for `python/supervisor/supervisor_helper.py`.
- Generated the Linux-specific `uv.lock`, completed `uv sync --frozen`, and confirmed that the lock contains `supervisor==4.3.0` and `multivisor==6.0.3` without Windows-only `supervisor-win` or `pywin32` packages.
- Passed Bash syntax and safety-preflight checks, Supervisor-template parsing and policy checks, Python helper syntax and byte-parity checks, README/repository consistency checks, ignore checks, and `git diff --check` on the Windows development host.
- Confirmed that importing the Unix Supervisor stack cannot run on the Windows host because Python's Unix-only `grp` module is unavailable; a real Linux systemd end-to-end run remains the operational verification milestone.
- Hardened the parity model with mode-0600 runtime config creation, trusted-interface-only Multivisor guidance, graceful `KillMode=mixed` systemd shutdown, setup preflight checks, and enforced LF endings for Bash scripts.
- Restored the Linux-native `supervisorctl` transport from the pre-split repository: a `0700` Unix socket handles CLI access while the loopback Web UI retains username/password authentication.
- Added `supervisorctl.sh` and made the global `supervisorctl` symlink target that wrapper, ensuring the canonical root config and Unix socket are used from any current directory.
- Revalidated with Supervisor 4.3.0 that the server and client resolve the same `%(here)s` socket, the socket mode parses as `0700`, and the loopback Web UI remains authenticated; Bash, README, lock, ignore, parity, and diff checks also passed on the Windows development host.

## 2026-07-20

- Consolidated tracked handoff documents and local agent notes under `.agents/` and removed the former handoff directory.
- Standardized the shared `.gitignore` blocks across the Linux and Windows repositories, including `.sc_history`, `.venv/`, and `.uv-cache/`; kept the Unix socket ignore Linux-specific.
- Removed the embedded `.agents/supervisor-windows/` checkout and its repository-level ignore rule.
- Switched future Windows parity comparison and paired edits to the sibling checkout at `C:\Users\Joon\Projects\supervisor`.
