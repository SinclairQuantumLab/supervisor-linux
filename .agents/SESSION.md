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

## 2026-09-12

- Compared clean Linux `main` at `931f993` with the Windows sibling at `9c91d5c` plus its current uncommitted Python/tkinter test and README changes. The working-tree Python probe, not the older committed PowerShell probe, is the source for this port.
- Added identical Python test source and example screenshot, a Linux Supervisor test config, and the matching six-step README walkthrough. Preserved all existing installation sections and runtime/dependency defaults.
- Retained the Windows opt-in test settings and separate stdout/stderr logs. Linux uses `.venv/bin/python`, `ENV_HOME`, forward-slash paths, its Unix-socket CLI, and a short Tk/desktop prerequisite note.
- Reconciled agent descriptions with the already-committed user-service setup and removed CLI wrapper; unrelated README/service issues remain separate work.
- Verified source/image parity, config option parity, Supervisor 4.3 config parsing, and actual Tk GUI updates, per-second stdout/stderr, and clean close on Windows. Linux desktop/user-service execution remains untested on this host.
- Mirrored the later Windows README at `3ae01c7`: added shared app-log location, update/start examples, and removal instructions to `Adding an app`; shortened the test section to copy its config and refer to the common steps. Kept Linux paths, unauthenticated Unix-socket CLI wording, and the existing Tk/desktop prerequisite note. No installation or runtime changes were made.
- Pre-commit review also mirrored Windows's narrowed `tests/.gitignore` exception (`!*.conf`), keeping generated logs and Python caches ignored. Rechecked source/image/helper byte parity, test-config and README parity with OS substitutions, Python/Bash syntax, the uv lock, and ignore rules. Recorded the pre-existing installation inconsistencies separately from this commit.
- Committed the GUI test and README mirror as `f5d8ff4`, with both Windows source commits recorded in the commit message.
- At the user's request, corrected the password substitution target and `WantedBy=default.target`, then aligned README quick/one-shot/manual setup, startup/shutdown, Multivisor, and uninstall with the existing user-service model. Filled the empty manual copy-command block, matched its unit example to the root template, and removed active references to the deleted CLI wrapper and older system-service helper. Preserved numbered installation items and the shared app/test sections.
- Verified 44 nonempty README code blocks, syntax of 37 Bash command blocks and all canonical Bash helpers, exact manual-unit/template equality, user-service command/path consistency, and the uv lock. Exercised README one-shot and manual setup plus scoped uninstall in temporary fixtures using real copy/substitution/link operations and simulated `git`, `uv`, and `systemctl`; no installed service or deployment files were touched. Real Linux login/systemd/GUI testing remains outstanding.
- Received the Developing supervisor-windows cleanup handoff from `.agents/AGENTS.local.md`, corresponding to Windows commit `242e267`. Removed the obsolete root `mount-supervisord-systemd.sh` and `Startup_supervisord.sh`, all five inherited `linux/` template/placeholder files, and the duplicate `REAME.old.md` that referenced them. Previous versions remain recoverable from Git history.
- Updated current agent rules and handoff state to stop retaining superseded setup paths. Preserved the current README, root user-service/config templates, `python/Startup.sh`, shared logging helper, tests, log placeholders, dependency files, and old-package removal instructions unchanged. README file links and 37 Bash command blocks, the active shell helper, Python syntax, Windows shared-file parity, the uv lock, and whitespace checks passed. No installed services or runtime configs were changed.

## 2026-11-06

- At the user's request, investigated the Multivisor example: root template creation in `97275b2` introduced `bind=<TRUSTED_INTERFACE_IP>:9002` instead of the inherited `bind=*:9002`, omitted the original conda comment and initial-test instructions, and moved the include-section explanation. The Windows reference and current Windows template retain the wildcard bind example.
- Restored `bind=*:9002`, the original conda comment, and the initial-test instructions in the root template. Matched the README example and removed its placeholder-specific restriction. Superseded the restricted-interface rule in current handoff state; historical session entries remain unchanged. The optional block remains commented out. No installed configuration, service, or Windows repository files were changed.
- The user then replaced the conda comment with `uncomment to connect to multivisor` and chose the compact `(<LISTENING_IP>:<PORT>)` inline comment. At the user's request, mirrored the final Multivisor block in the sibling Windows template for paired commits and pushes. The historical initial-test instructions remain Linux-specific.
- Verified identical Multivisor blocks, unchanged active settings in both templates, the matching Linux README bind example, and clean whitespace checks. Both local `main` branches matched their fetched `origin/main` before committing.
