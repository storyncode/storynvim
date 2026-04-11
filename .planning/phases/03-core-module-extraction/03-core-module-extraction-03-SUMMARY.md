---
phase: 03-core-module-extraction
plan: 03
subsystem: infra
tags: [neovim, lua, autocmds, bootstrap, runtimepath]
requires:
  - phase: 03-02
    provides: extracted core options, diagnostics, and keymaps with ordered bootstrap delegation
provides:
  - `lua/core/autocmds.lua` for the yank highlight autocmd
  - final explicit core-versus-runtime bootstrap structure
  - passing repo-entrypoint headless smoke verification for Phase 03
affects: [phase-04-compatibility-and-cleanup, phase-05-documentation-refresh, startup]
tech-stack:
  added: []
  patterns: [core-autocmd ownership, post-lazy runtimepath reapply]
key-files:
  created: [lua/core/autocmds.lua]
  modified: [lua/story/bootstrap.lua]
key-decisions:
  - "Kept the yank highlight autocmd as the only extracted always-on autocmd in this phase."
  - "Preserved explicit `require('core.*').setup()` calls instead of introducing a dynamic loader."
patterns-established:
  - "Bootstrap reads as core setup, runtime helpers, then plugin-manager setup."
  - "Repo-entrypoint smoke checks verify both behavior and post-startup runtimepath visibility."
requirements-completed: [CORE-03]
duration: 1min
completed: 2026-04-11
---

# Phase 03 Plan 03: Core Module Extraction Summary

**Always-on yank highlight autocmd extracted into `lua/core/autocmds.lua` with bootstrap finalized as the core/runtime boundary**

## Performance

- **Duration:** 1 min
- **Started:** 2026-04-11T20:10:52Z
- **Completed:** 2026-04-11T20:12:00Z
- **Tasks:** 2
- **Files modified:** 2

## Accomplishments
- Added `lua/core/autocmds.lua` for the always-on yank highlight autocmd.
- Finalized bootstrap so it clearly separates core setup, runtime helpers, and plugin-manager setup.
- Passed a combined headless smoke test covering options, diagnostics, global keymaps, yank highlighting, clipboard scheduling, runtimepath visibility, and `+checkhealth kickstart`.

## Task Commits

Execution completed in the current worktree without creating plan-local commits.

## Files Created/Modified
- `lua/core/autocmds.lua` - owns the `TextYankPost` highlight autocmd and augroup.
- `lua/story/bootstrap.lua` - now orchestrates all four core modules plus runtime and plugin-manager setup.

## Decisions Made
- Kept explicit `require('core.options').setup()` style calls to preserve readable startup ordering.
- Reapplied the resolved repo root to runtimepath after `lazy.setup(...)` so repo-entrypoint verification remains valid after startup completes.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Restored checkout runtimepath after plugin-manager setup**
- **Found during:** Task 2 (Finalize bootstrap as the explicit core-versus-runtime orchestrator)
- **Issue:** Even after resolving the real repo root, `lazy.setup(...)` removed that path from the final runtimepath, so the plan’s runtimepath assertion still failed after startup.
- **Fix:** Reapplied `vim.opt.rtp:prepend(config_root)` after `require('lazy').setup(...)`.
- **Files modified:** `lua/story/bootstrap.lua`
- **Verification:** A combined headless smoke test now passes `vim.tbl_contains(vim.opt.rtp:get(), vim.fn.getcwd())` together with `+checkhealth kickstart`.
- **Committed in:** None

---

**Total deviations:** 1 auto-fixed (1 blocking)
**Impact on plan:** The fix preserved the desired bootstrap structure while making the repo-entrypoint verification path reliable after full startup.

## Issues Encountered

- `lazy.nvim` mutates `runtimepath` during startup, so repo-entrypoint invariants must be reasserted after plugin setup if they matter to verification.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- Phase 03 is ready for `/gsd-verify-work`; all three Phase 03 plan summaries now exist.
- Phase 04 can focus on compatibility cleanup rather than further core-structure extraction.

## Self-Check: PASSED

- Found summary file: `.planning/phases/03-core-module-extraction/03-core-module-extraction-03-SUMMARY.md`
- Verified created file: `lua/core/autocmds.lua`
