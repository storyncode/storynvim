---
phase: 02-plugin-import-layout
plan: 02
subsystem: ui
tags: [neovim, lazy.nvim, plugins, lua, lsp, treesitter]
requires:
  - phase: 02-plugin-import-layout
    provides: editor and telescope concern modules under `lua/plugins/`
provides:
  - remaining shipped concern modules for lsp, coding, and ui plugins
  - preserved LSP, formatting, completion, Treesitter, and colorscheme spec bodies outside bootstrap
affects: [02-03, lua/story/bootstrap.lua, lazy.nvim imports]
tech-stack:
  added: []
  patterns: [concern-oriented LazySpec modules, verbatim plugin spec extraction]
key-files:
  created: [lua/plugins/lsp.lua, lua/plugins/coding.lua, lua/plugins/ui.lua]
  modified: []
key-decisions:
  - "Copied the remaining shipped plugin specs into concern files with their existing config closures intact instead of refactoring behavior during extraction."
  - "Kept `lua/kickstart/plugins/` and `lua/custom/plugins/` untouched so import wiring remains a separate concern for plan 02-03."
patterns-established:
  - "Concern modules return list-style LazySpecs so multiple related shipped plugins can live in one file."
  - "Bootstrap plugin bodies are migrated by copy-first extraction to reduce regression risk before rewiring imports."
requirements-completed: [PLUG-02]
duration: 4min
completed: 2026-04-11
---

# Phase 2 Plan 2: Plugin Import Layout Summary

**Concern-based LazySpec modules now own the shipped LSP, formatting, completion, Treesitter, and UI plugin specs under `lua/plugins/`.**

## Performance

- **Duration:** 4min
- **Started:** 2026-04-11T18:05:00Z
- **Completed:** 2026-04-11T18:09:01Z
- **Tasks:** 2
- **Files modified:** 3

## Accomplishments
- Added `lua/plugins/lsp.lua` with the existing `nvim-lspconfig` and `conform.nvim` specs, including Mason setup, `LspAttach`, and format-on-save behavior.
- Added `lua/plugins/coding.lua` with the existing `blink.cmp` and `nvim-treesitter` specs, preserving snippet build hooks and Treesitter auto-attach/install logic.
- Added `lua/plugins/ui.lua` with the existing colorscheme, todo-comments, and mini.nvim specs while leaving optional namespaces untouched.

## Task Commits

Each task was committed atomically:

1. **Task 1: Create the language tooling concern module** - `5dd4a72` (feat)
2. **Task 2: Create the coding and UI concern modules** - `cd8dafc` (feat)

**Plan metadata:** Pending docs commit

## Files Created/Modified
- `lua/plugins/lsp.lua` - Concern module for shipped LSP and formatting plugin specs.
- `lua/plugins/coding.lua` - Concern module for shipped completion and Treesitter plugin specs.
- `lua/plugins/ui.lua` - Concern module for shipped colorscheme and UI utility plugin specs.

## Decisions Made
- Copied plugin specs mostly verbatim from `lua/story/bootstrap.lua` so the extraction stays structural and does not risk hidden behavior changes.
- Left `kickstart` and `custom` plugin namespaces untouched because this plan’s scope is shipped concern modules only.

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- `lua/plugins/` now contains all shipped concern modules needed for the Phase 2 import switch.
- `lua/story/bootstrap.lua` still owns the inline plugin table, so plan `02-03` can focus on import wiring and parity verification without more extraction work.

## Self-Check: PASSED

- Verified created files exist: `lua/plugins/lsp.lua`, `lua/plugins/coding.lua`, `lua/plugins/ui.lua`, and this summary file.
- Verified task commits exist: `5dd4a72` and `cd8dafc`.

---
*Phase: 02-plugin-import-layout*
*Completed: 2026-04-11*
