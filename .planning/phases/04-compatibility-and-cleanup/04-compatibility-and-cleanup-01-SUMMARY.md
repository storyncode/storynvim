---
phase: 04-compatibility-and-cleanup
plan: 01
subsystem: infra
tags: [neovim, lazy.nvim, lua, plugins, compatibility]
requires:
  - phase: 02-plugin-import-layout-03
    provides: import-based lazy.nvim plugin registration from `lua/plugins`
  - phase: 03-core-module-extraction-03
    provides: bootstrap runtimepath guards and repo-entrypoint headless verification
provides:
  - active `custom.plugins` import wiring in bootstrap
  - legacy `kickstart.plugins.*` guidance preserved as explicit example opt-ins
  - optional overlay composition for `kickstart.plugins.gitsigns`
affects: [phase-04-02, plugin-loading, health-checks]
tech-stack:
  added: []
  patterns: [active custom plugin namespace, legacy optional overlay specs]
key-files:
  created: []
  modified: [lua/story/bootstrap.lua, lua/kickstart/plugins/gitsigns.lua]
key-decisions:
  - "Keep `plugins` as the only shipped plugin import source while activating `custom.plugins` alongside it."
  - "Treat `kickstart.plugins.gitsigns` as an optional overlay so legacy keymaps compose with the shipped base spec."
patterns-established:
  - "Bootstrap activates the user-owned `custom.plugins` namespace without importing `kickstart.plugins` wholesale."
  - "Legacy example modules that target already-shipped plugins should declare `optional = true` when used as overlays."
requirements-completed: [PLUG-03, PAR-03]
duration: 1min
completed: 2026-04-11
---

# Phase 04 Plan 01: Compatibility and Cleanup Summary

**Bootstrap now activates `custom.plugins` as the stable extension path while legacy Kickstart plugin examples remain opt-in overlays**

## Performance

- **Duration:** 1 min
- **Started:** 2026-04-11T21:10:54Z
- **Completed:** 2026-04-11T21:11:57Z
- **Tasks:** 2
- **Files modified:** 2

## Accomplishments
- Added an active `{ import = 'custom.plugins' }` entry in bootstrap without introducing a second shipped plugin namespace.
- Rewrote the nearby bootstrap guidance so `custom.plugins` is the stable user path and `kickstart.plugins.*` stays legacy/example-only.
- Marked `kickstart.plugins.gitsigns` as an optional overlay so it composes with the shipped gitsigns spec in `lua/plugins/editor.lua`.

## Task Commits

Each task was committed atomically:

1. **Task 1: Make `custom.plugins` the active stable extension path without changing the shipped plugin source** - `a0c1f2a` (feat)
2. **Task 2: Make the legacy gitsigns module an explicit overlay instead of a competing primary spec** - `92efaa5` (fix)

## Files Created/Modified
- `lua/story/bootstrap.lua` - activates `custom.plugins` and updates the compatibility guidance around shipped versus legacy plugin namespaces.
- `lua/kickstart/plugins/gitsigns.lua` - declares the legacy gitsigns module as an optional overlay spec.

## Decisions Made
- Activated `custom.plugins` directly in bootstrap instead of leaving it as commented guidance, because Phase 4 requires it to be the stable active extension path.
- Left `kickstart.plugins.*` as commented opt-ins and avoided any `{ import = 'kickstart.plugins' }` namespace import to preserve a single shipped source of truth.

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- Phase 04-02 can build on a stable compatibility boundary: shipped specs from `lua/plugins`, active user extensions from `lua/custom/plugins`, and legacy examples remaining explicit opt-ins.
- Headless validation is green for both task-level checks and the plan-level parity suite through `init.lua`.

## Self-Check: PASSED

- Found summary file: `.planning/phases/04-compatibility-and-cleanup/04-compatibility-and-cleanup-01-SUMMARY.md`
- Found commit: `a0c1f2a`
- Found commit: `92efaa5`

---
*Phase: 04-compatibility-and-cleanup*
*Completed: 2026-04-11*
