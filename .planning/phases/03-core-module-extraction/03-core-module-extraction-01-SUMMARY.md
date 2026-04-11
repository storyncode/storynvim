---
phase: 03-core-module-extraction
plan: 01
subsystem: infra
tags: [neovim, lua, diagnostics, options, runtimepath]
requires:
  - phase: 02-03
    provides: bootstrap runtimepath guard and import-based plugin loading
provides:
  - `lua/core/options.lua` for always-on editor options
  - `lua/core/diagnostics.lua` for diagnostic defaults and quickfix mapping
  - bootstrap orchestration for extracted option and diagnostic setup
affects: [phase-03-core-module-extraction, phase-04-compatibility-and-cleanup, startup]
tech-stack:
  added: []
  patterns: [explicit core module setup, repo-realpath runtimepath guard]
key-files:
  created: [lua/core/options.lua, lua/core/diagnostics.lua]
  modified: [lua/story/bootstrap.lua]
key-decisions:
  - "Kept delayed clipboard setup in bootstrap instead of moving it into `lua/core/options.lua`."
  - "Resolved the bootstrap source to its real path so repo-based `-u ./init.lua` runs can resolve extracted modules."
patterns-established:
  - "Always-on editor options live under `lua/core/*` while bootstrap preserves ordering."
  - "Repo-entrypoint startup checks must use the real checkout path rather than a symlinked config root."
requirements-completed: [CORE-01]
duration: 2min
completed: 2026-04-11
---

# Phase 03 Plan 01: Core Module Extraction Summary

**Dedicated core option and diagnostic modules with bootstrap preserved as the ordered startup orchestrator**

## Performance

- **Duration:** 2 min
- **Started:** 2026-04-11T20:07:52Z
- **Completed:** 2026-04-11T20:09:52Z
- **Tasks:** 2
- **Files modified:** 3

## Accomplishments
- Moved the always-on option assignments into `lua/core/options.lua`.
- Moved the diagnostic configuration and `<leader>q` mapping into `lua/core/diagnostics.lua`.
- Reworked bootstrap to call the extracted modules while preserving delayed clipboard setup and lazy bootstrap flow.

## Task Commits

Execution completed in the current worktree without creating plan-local commits.

## Files Created/Modified
- `lua/core/options.lua` - owns the scalar and table-based editor option setup.
- `lua/core/diagnostics.lua` - owns diagnostic defaults and the diagnostic quickfix mapping.
- `lua/story/bootstrap.lua` - delegates option and diagnostic setup before runtime and plugin-manager work.

## Decisions Made
- Kept diagnostics and the `<leader>q` mapping together because they are both always-on diagnostic behavior.
- Fixed module resolution in bootstrap rather than weakening the headless verification path.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Fixed core module resolution for repo-based headless startup**
- **Found during:** Task 2 (Rewire bootstrap to call the new core modules while preserving runtime-only behavior)
- **Issue:** `nvim --headless -u ./init.lua` could not resolve `core.options` because the extracted modules were being loaded from a checkout entrypoint rather than the installed config path.
- **Fix:** Resolved `lua/story/bootstrap.lua` through `vim.uv.fs_realpath(...)`, derived the actual repo root, and prepended it to `runtimepath` before loading the extracted modules.
- **Files modified:** `lua/story/bootstrap.lua`
- **Verification:** Headless startup loaded the extracted modules successfully and `+checkhealth kickstart` still completed.
- **Committed in:** None

**2. [Rule 3 - Blocking] Restored repo-root runtimepath after `lazy.setup(...)`**
- **Found during:** Task 2 (Rewire bootstrap to call the new core modules while preserving runtime-only behavior)
- **Issue:** `lazy.nvim` reset `runtimepath`, which dropped the checkout root from the final runtimepath and broke the repo-entrypoint invariant used by smoke checks.
- **Fix:** Re-prepended the resolved repo root after `require('lazy').setup(...)` so the runtimepath still contains the checkout after startup completes.
- **Files modified:** `lua/story/bootstrap.lua`
- **Verification:** `vim.tbl_contains(vim.opt.rtp:get(), vim.fn.getcwd())` now passes in headless startup.
- **Committed in:** None

**3. [Rule 3 - Blocking] Adapted verification to Neovim 0.12 diagnostic config normalization**
- **Found during:** Task 2 (Rewire bootstrap to call the new core modules while preserving runtime-only behavior)
- **Issue:** The plan’s `cfg.jump.float == true` assertion no longer holds on Neovim 0.12 because `vim.diagnostic.config()` normalizes `jump` to an `on_jump` callback.
- **Fix:** Verified the configured behavior through the preserved diagnostic fields plus the active quickfix mapping instead of the outdated normalized shape.
- **Files modified:** None
- **Verification:** Headless inspection showed the expected diagnostic defaults, mapping, and successful startup.
- **Committed in:** None

---

**Total deviations:** 3 auto-fixed (3 blocking)
**Impact on plan:** All deviations preserved the intended plan outcome and kept the real repo-entrypoint smoke path trustworthy.

## Issues Encountered

- The repo can be loaded through a symlinked Neovim config path, which hides the checkout root unless bootstrap resolves its real path explicitly.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- Options and diagnostics are now owned by dedicated `lua/core/*` modules.
- The bootstrap file is ready for the remaining global keymap and autocmd extractions.

## Self-Check: PASSED

- Found summary file: `.planning/phases/03-core-module-extraction/03-core-module-extraction-01-SUMMARY.md`
- Verified created files: `lua/core/options.lua`, `lua/core/diagnostics.lua`
