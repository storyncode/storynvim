---
phase: 02-plugin-import-layout
plan: 01
subsystem: plugins
tags: [neovim, lazy.nvim, telescope, lua, modularization]
requires:
  - phase: 01-bootstrap-skeleton
    provides: thin init.lua entrypoint and stable lazy.nvim bootstrap helper
provides:
  - "Editor concern plugin module for guess-indent, gitsigns, and which-key"
  - "Telescope concern plugin module with preserved dependencies, keymaps, and LspAttach hooks"
affects: [plugin-import-layout, lazy.nvim, telescope, startup-parity]
tech-stack:
  added: []
  patterns: [concern-oriented LazySpec modules, verbatim plugin-spec extraction]
key-files:
  created: [lua/plugins/editor.lua, lua/plugins/telescope.lua]
  modified: []
key-decisions:
  - "Keep this plan as a pure extraction step with no bootstrap wiring changes."
  - "Preserve plugin runtime behavior by copying existing specs and config closures nearly verbatim."
patterns-established:
  - "Active shipped plugins can be split into concern files under lua/plugins before import wiring flips over."
  - "Large plugin config closures should move as intact units to minimize behavioral drift during modularization."
requirements-completed: [PLUG-02]
duration: 3min
completed: 2026-04-11
---

# Phase 02 Plan 01: Plugin Import Layout Summary

**Concern-oriented LazySpec modules for editor tooling and Telescope now exist under `lua/plugins` with current runtime hooks preserved for later import wiring**

## Performance

- **Duration:** 3 min
- **Started:** 2026-04-11T18:01:00Z
- **Completed:** 2026-04-11T18:03:38Z
- **Tasks:** 2
- **Files modified:** 2

## Accomplishments
- Extracted the shipped editor-facing plugin specs into `lua/plugins/editor.lua`.
- Extracted the full Telescope spec into `lua/plugins/telescope.lua` with its dependencies, extension loading, keymaps, and `LspAttach` autocmd intact.
- Verified both modules export LazySpec tables and match the plan’s structural grep checks.

## Task Commits

Each task was committed atomically:

1. **Task 1: Create the editor concern plugin module** - `65d5b5d` (feat)
2. **Task 2: Create the telescope concern plugin module** - `6089179` (feat)

## Files Created/Modified
- `lua/plugins/editor.lua` - Editor concern LazySpec list for guess-indent, gitsigns, and which-key.
- `lua/plugins/telescope.lua` - Telescope concern LazySpec with preserved dependency and config behavior.

## Decisions Made
- Kept bootstrap wiring unchanged so the new concern files can be reviewed independently before plan `02-03` switches `lazy.setup` imports.
- Treated the bootstrap plugin blocks as the canonical source and copied their runtime values directly instead of refactoring config bodies.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Plan verifier conflict] Removed a forbidden namespace example from a Telescope comment**
- **Found during:** Task 2 (Create the telescope concern plugin module)
- **Issue:** The live bootstrap comment mentioned `custom.plugins.snacks`, but the plan’s acceptance criteria explicitly required no `custom.plugins` matches in `lua/plugins/telescope.lua`.
- **Fix:** Reworded the comment to remove the namespace example while leaving the Telescope spec and runtime behavior unchanged.
- **Files modified:** `lua/plugins/telescope.lua`
- **Verification:** Task 2 verifier passed after the comment update.
- **Committed in:** `6089179`

---

**Total deviations:** 1 auto-fixed (1 rule 1)
**Impact on plan:** The deviation resolved an internal plan conflict without changing runtime behavior or widening scope.

## Issues Encountered
None

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- `lua/plugins/editor.lua` and `lua/plugins/telescope.lua` are ready for the remaining concern-file extraction work in plan `02-02`.
- Later import wiring can now point at `lua/plugins` without re-extracting these shipped specs.

## Self-Check: PASSED
- Found `.planning/phases/02-plugin-import-layout/02-plugin-import-layout-01-SUMMARY.md`
- Found `lua/plugins/editor.lua`
- Found `lua/plugins/telescope.lua`
- Found commit `65d5b5d`
- Found commit `6089179`

---
*Phase: 02-plugin-import-layout*
*Completed: 2026-04-11*
