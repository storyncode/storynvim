---
phase: 05-documentation-refresh
plan: 01
subsystem: documentation
tags: [readme, neovim, lua, modular-architecture, onboarding]
requires:
  - phase: 04-compatibility-and-cleanup
    provides: stable `custom.plugins` extension guidance and legacy `kickstart.plugins` compatibility positioning
provides:
  - README guidance aligned with the modular StoryNvim runtime layout
  - architecture map rooted in `require('story.bootstrap').setup()`
  - customization guidance pointing to `lua/core/`, `lua/plugins/`, and `lua/custom/plugins/`
affects: [README.md, onboarding, customization-guidance, docs]
tech-stack:
  added: []
  patterns: [README as architecture map, module-based customization guidance]
key-files:
  created: [.planning/phases/05-documentation-refresh/05-documentation-refresh-01-SUMMARY.md]
  modified: [README.md]
key-decisions:
  - "Retitled the README around StoryNvim while keeping upstream Kickstart references only where they remain historically or operationally accurate."
  - "Documented `lua/custom/plugins/` as the stable fork-local extension surface and `lua/kickstart/plugins/` as compatibility/example-only."
patterns-established:
  - "Docs should explain `init.lua` as a thin entrypoint calling `require('story.bootstrap').setup()`."
  - "Customization guidance should route readers by ownership boundary: `lua/core/`, `lua/plugins/`, then `lua/custom/plugins/`."
requirements-completed: [DOC-01, DOC-02]
duration: 1min
completed: 2026-04-11
---

# Phase 05 Plan 01: README modular architecture rewrite summary

**README onboarding now teaches StoryNvim's modular runtime, entrypoint handoff, and safe customization paths across `lua/core/`, `lua/plugins/`, and `lua/custom/plugins/`.**

## Performance

- **Duration:** 1 min
- **Started:** 2026-04-11T22:59:19+01:00
- **Completed:** 2026-04-11T23:00:32+01:00
- **Tasks:** 2
- **Files modified:** 1

## Accomplishments
- Replaced the README's old Kickstart single-file positioning with StoryNvim-specific modular onboarding.
- Added an architecture map showing `init.lua` as a thin entrypoint into `require('story.bootstrap').setup()`.
- Rewrote customization and FAQ guidance so active changes route to `lua/core/`, `lua/plugins/`, and `lua/custom/plugins/`, with `lua/kickstart/plugins/` marked legacy/example-only.

## Task Commits

Each task was committed atomically:

1. **Task 1: Reframe README identity and architecture around the modular runtime** - `085f215` (docs)
2. **Task 2: Replace stale README customization guidance and FAQ language** - `135963a` (docs)

## Files Created/Modified
- `README.md` - Primary onboarding guide updated to reflect the modular runtime and current customization surfaces.
- `.planning/phases/05-documentation-refresh/05-documentation-refresh-01-SUMMARY.md` - Execution summary for this plan.

## Decisions Made
- Centered the README on StoryNvim's current runtime structure instead of upstream Kickstart's historical single-file teaching model.
- Kept install and dependency material that still applies while updating clone examples and naming to this fork.
- Used a dedicated customization section plus FAQ entries to steer readers toward the active module ownership boundaries.

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

- Verification commands that included backticks needed shell-safe quoting adjustments during execution; the final content was verified with equivalent grep checks.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- README now matches the modular code layout and Phase 4 customization-path decisions.
- Remaining documentation surfaces can build on the same ownership model without revisiting README positioning.

## Self-Check: PASSED

- Found summary file: `.planning/phases/05-documentation-refresh/05-documentation-refresh-01-SUMMARY.md`
- Found task commit: `085f215`
- Found task commit: `135963a`

---
*Phase: 05-documentation-refresh*
*Completed: 2026-04-11*
