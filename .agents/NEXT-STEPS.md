# .agents/NEXT-STEPS.md

## Current state

- The Linux split is complete in commit `ce1631d`; the standard `AGENTS.md` rename is recorded in `f24a4d3`.
- Post-split parity development has established the canonical root `uv`/config model and the non-root systemd runtime flow.
- All README installation, usage, and uninstall paths now use the root user-service template from `2a0183b`, with the corrected `default.target`. Older helpers must not override this setup.
- The portable Windows GUI/logging test is now mirrored under `tests/`. Its Python source and screenshot are shared; the compact README test section reuses the common numbered app-management steps, matching Windows `3ae01c7`.
- The inherited `linux/` tree is legacy-only, and Windows parity work uses `C:\Users\Joon\Projects\supervisor` directly with no embedded comparison checkout.
- Static configuration, lock, shell, and repository validation passed on the Windows development host on 2026-07-18. A real Linux systemd end-to-end test remains outstanding.

## Resume checklist

1. Read `AGENTS.md`.
2. Read `.agents/PROJECT_STATE.md`, `.agents/DECISIONS.md`, `.agents/SESSION.md`, and this file.
3. Read any relevant `.agents/*.local.md` files, then inspect `git status` before assuming the parity work is committed.
4. Inspect Git status independently in this repository and `C:\Users\Joon\Projects\supervisor`; never combine their staging or commit operations.
5. Re-run static checks after any edits: `git diff --check`, `bash -n` on all canonical shell scripts, Python syntax checks without generating tracked artifacts, and `uv lock --check`.
6. On a Linux desktop, follow the child-test walkthrough: copy its config, update/start, observe one GUI and separate per-second logs, then remove the config and update again. Confirm Tk and the user service's desktop-display access first if startup fails.
7. Verify the primary user service with `systemctl --user` and its direct foreground daemon command on Linux, including enablement under `default.target`, login autostart, stop/restart, and uninstall.
8. Review plain CLI config discovery inside and outside the repository separately; do not restore the removed wrapper or redesign CLI usage during unrelated test work.
9. Walk through the README commands from a clean `~/Projects/supervisor` checkout, including the manual systemd path, Web UI/CLI checks, trusted-interface Multivisor setup, and uninstall flow.
10. Recheck parity-sensitive values and byte equality of `python/supervisor/supervisor_helper.py` against `C:\Users\Joon\Projects\supervisor`, applying paired edits there only when they are in scope.
11. Update durable `.agents/*.md` state after validation. Use `.agents/*.local.md` only for machine-specific observations.
12. Commit or push the parity work only when the user explicitly asks for it.
