# .agents/NEXT-STEPS.md

## Current state

- The Linux split is complete in commit `ce1631d`; the standard `AGENTS.md` rename is recorded in `f24a4d3`.
- Post-split parity development has established the canonical root `uv`/config model and the non-root systemd runtime flow.
- The inherited `linux/` tree is legacy-only, and Windows parity work uses `C:\Users\Joon\Projects\supervisor` directly with no embedded comparison checkout.
- Static configuration, lock, shell, and repository validation passed on the Windows development host on 2026-07-18. A real Linux systemd end-to-end test remains outstanding.

## Resume checklist

1. Read `AGENTS.md`.
2. Read `.agents/PROJECT_STATE.md`, `.agents/DECISIONS.md`, `.agents/SESSION.md`, and this file.
3. Read any relevant `.agents/*.local.md` files, then inspect `git status` before assuming the parity work is committed.
4. Inspect Git status independently in this repository and `C:\Users\Joon\Projects\supervisor`; never combine their staging or commit operations.
5. Re-run static checks after any edits: `git diff --check`, `bash -n` on all canonical shell scripts, Python syntax checks without generating tracked artifacts, and `uv lock --check`.
6. In a clean Linux environment, run `uv sync --frozen`, materialize `supervisord.conf`, verify that plain `supervisorctl` works through the `0700` Unix socket both inside and outside the repository, and confirm that the loopback Web UI still requires its configured credentials.
7. Run `systemd-analyze verify` on the generated unit, then perform the privileged end-to-end flow on a real systemd host: register, enable, start, inspect status, restart, and stop `supervisor`.
8. Confirm that systemd runs the unit as the configured non-root user, `Startup_supervisord.sh` keeps supervisord in foreground mode, and child apps load from `conf.d/*.conf`.
9. Walk through the README commands from a clean `~/Projects/supervisor` checkout, including the manual systemd path, Web UI/CLI checks, trusted-interface Multivisor setup, and uninstall flow.
10. Recheck parity-sensitive values and byte equality of `python/supervisor/supervisor_helper.py` against `C:\Users\Joon\Projects\supervisor`, applying paired edits there only when they are in scope.
11. Update durable `.agents/*.md` state after validation. Use `.agents/*.local.md` only for machine-specific observations.
12. Commit or push the parity work only when the user explicitly asks for it.
