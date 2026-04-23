# AGENT.md

## Purpose

- This repository documents how to use `supervisor` on Linux.
- This repository is for README, templates, helper scripts, and operational tricks around `supervisor`.
- Do not modify, vendor, or treat the upstream `supervisor` project itself as part of this repository.

## Locked project boundaries

- The original mixed repository was split on 2026-04-17.
- `supervisor-linux` is the active repository/folder for Linux-only materials.
- `C:\Users\Joon\Projects\supervisor-windows` exists as the Windows-side split sibling for comparison and symmetry.
- Until the user explicitly asks otherwise, preserve inherited content as much as possible.
- Do not do drive-by rewrites, wording cleanup, style normalization, or template redesign unless the user asks for it.

## Current repository layout

- `README.md`: Linux-only usage guide extracted from the old mixed repository.
- `linux/`: Linux supervisor templates and service files.
- `python/Startup_bash`: Linux launcher helper.
- `python/supervisor/supervisor_helper.py`: shared Python logging helper.

## Context handoff policy

- `AGENT.md` is the durable, tracked source of truth for repo purpose, boundaries, and workflow rules.
- `.codex/PROJECT_STATE.md` is the durable, tracked snapshot of current repository state, important cautions, and active phase.
- `.codex/DECISIONS.md` is the durable, tracked record of locked decisions and non-obvious constraints.
- `.codex/SESSION.md` is the durable, tracked milestone log for major repository events.
- `.codex/NEXT-STEPS.md` is the durable, tracked resumption checklist and next-action queue.
- `.codex/*.local.md` is reserved for machine-specific, worktree-specific, or thread-specific notes that should not be committed.
- Durable handoff context should live in tracked `.codex/*.md` files; only true local notes should be ignored.

## Required agent workflow

- At the start of work, read `AGENT.md` first.
- Then read `.codex/PROJECT_STATE.md`, `.codex/DECISIONS.md`, `.codex/SESSION.md`, and `.codex/NEXT-STEPS.md`.
- If relevant local notes exist, read `.codex/*.local.md` before making new assumptions.
- When durable repo state or decisions change, update the tracked `.codex/*.md` files before finishing.
- When temporary machine/worktree/thread context matters, write it under `.codex/*.local.md`.
- Keep `AGENT.md` stable. Update it only for durable rules, durable structure changes, or durable project-state milestones.

## Working rules

- Treat this repository as a usage/support repository for `supervisor`, not as the upstream project.
- Prefer minimal, explicit edits over broad cleanup.
- If you need Windows comparison while working on Linux material, use `C:\Users\Joon\Projects\supervisor-windows`.
- If a future task starts real post-split development, keep the split-history constraints in mind and record the new phase in `AGENT.md`, `.codex/PROJECT_STATE.md`, and `.codex/SESSION.md`.

## Current status

- Linux split is now documented with a Linux-only README.
- The extracted Linux files live under `linux/` and `python/`.
- Git is initialized in `C:\Users\Joon\Projects\supervisor-linux` and connected to the GitHub remote.
- Current commit history still follows the mirrored `supervisor-setting` lineage; the Linux-only split work is still represented as worktree changes rather than a Linux-side split commit.
- Durable handoff context now lives in tracked files under `.codex/`; only `.local.md` notes are ignored.
- No post-split Linux-specific feature development has started yet.
