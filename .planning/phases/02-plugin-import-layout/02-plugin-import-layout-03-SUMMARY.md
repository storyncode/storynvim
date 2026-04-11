---
phase: 02-plugin-import-layout
plan: 03
subsystem: infra
tags: [neovim, lazy.nvim, lua, plugins, runtimepath]
requires:
  - phase: 02-01
    provides: editor and telescope concern plugin modules
  - phase: 02-02
    provides: lsp, coding, and ui concern plugin modules
provides:
  - import-based lazy.nvim plugin registration from `lua/plugins`
  - removal of the shipped inline plugin table from bootstrap
  - headless startup compatibility for repo-based `init.lua` verification
affects: [phase-03-core-module-extraction, phase-04-compatibility-and-cleanup, plugin-loading]
tech-stack:
  added: []
  patterns: [lazy spec import namespace, bootstrap runtimepath guard for repo execution]
key-files:
  created: []
  modified: [lua/story/bootstrap.lua]
key-decisions:
  - "Use `spec = { { import = 'plugins' } }` as the only shipped plugin source in bootstrap."
  - "Prepend the repo root to `runtimepath` during bootstrap so `nvim -u ./init.lua` can resolve `lua/plugins` in checkout-based smoke runs."
patterns-established:
  - "Bootstrap owns import wiring while concern specs live entirely under `lua/plugins`."
  - "Headless verification should exercise the real repo entrypoint without depending on `stdpath('config')`."
requirements-completed: [PLUG-01, PLUG-02]
duration: 2min
completed: 2026-04-11
---

# Phase 02 Plan 03: Plugin Import Layout Summary

**Canonical lazy.nvim import wiring from `lua/plugins` with the shipped inline plugin table removed from bootstrap**

## Performance

- **Duration:** 2 min
- **Started:** 2026-04-11T19:20:12Z
- **Completed:** 2026-04-11T19:22:01Z
- **Tasks:** 2
- **Files modified:** 1

## Accomplishments
- Switched `lua/story/bootstrap.lua` to `spec = { { import = 'plugins' } }` as the shipped plugin source of truth.
- Removed the old monolithic inline plugin list while preserving the Kickstart/custom extension guidance and UI icon options.
- Passed the structural checks and headless `+Lazy! health` / `+checkhealth kickstart` smoke suite through `init.lua`.

## Task Commits

Each task was committed atomically:

1. **Task 1: Replace the inline plugin table with the canonical import spec** - `8269f4d` (feat)
2. **Task 2: Run the phase structural and headless smoke suite** - `77f2c12` (fix)

## Files Created/Modified
- `lua/story/bootstrap.lua` - switches lazy.nvim to import-driven plugin registration and adds the repo runtimepath guard needed for headless repo-entrypoint verification.

## Decisions Made
- Kept the bootstrap comments for `kickstart.plugins.*` and `custom.plugins` as commented guidance so extension points remain visible without becoming active shipped specs.
- Fixed import discovery in bootstrap rather than changing the verification command, because the plan requires the real `init.lua` smoke path to pass.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Fixed repo checkout import discovery for headless startup**
- **Found during:** Task 2 (Run the phase structural and headless smoke suite)
- **Issue:** `nvim --headless -u ./init.lua "+Lazy! health" "+checkhealth kickstart" +qa` failed with `No specs found for module "plugins"` because `stdpath('config')` still pointed at `~/.config/nvim` during repo-based execution.
- **Fix:** Prepended the repository root derived from `lua/story/bootstrap.lua` to `runtimepath` before `lazy.nvim` setup so the `plugins` import resolves from the checked-out repo.
- **Files modified:** `lua/story/bootstrap.lua`
- **Verification:** The full structural grep and headless smoke command completed successfully with exit code `0`.
- **Committed in:** `77f2c12`

---

**Total deviations:** 1 auto-fixed (1 blocking)
**Impact on plan:** The auto-fix was required for the planned verification path to work correctly. No scope creep.

## Issues Encountered

- `lazy.nvim` import discovery depends on runtimepath visibility of `lua/plugins`, which was not guaranteed when executing the repo via `-u ./init.lua`.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- Phase 2’s import layout is complete and verified; Phase 3 can now extract core editor behavior without plugin registration still living inline in bootstrap.
- The runtimepath guard keeps repo-based smoke checks aligned with future plan verification commands.

## Self-Check: PASSED

- Found summary file: `.planning/phases/02-plugin-import-layout/02-plugin-import-layout-03-SUMMARY.md`
- Found commit: `8269f4d`
- Found commit: `77f2c12`
