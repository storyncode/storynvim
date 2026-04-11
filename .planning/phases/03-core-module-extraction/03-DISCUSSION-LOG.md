# Phase 3: Core Module Extraction - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-04-11T19:46:35Z
**Phase:** 3-Core Module Extraction
**Areas discussed:** Module Boundaries, Bootstrap Ownership, Namespace and Naming, Teaching Style

---

## Module Boundaries

| Option | Description | Selected |
|--------|-------------|----------|
| Strict | Only `options.lua`, `keymaps.lua`, and `autocmds.lua`; everything else stays in `bootstrap.lua` | |
| Mostly strict | Those three modules, plus one small shared helper/core module if needed | |
| Flexible | Planner may introduce whatever small internal modules make the extraction cleaner | ✓ |

**User's choice:** Flexible
**Notes:** A shared helper module is acceptable. The extracted structure should still make options, keymaps, and autocommands recognizable, but clarity matters more than mirroring roadmap wording exactly.

---

## Bootstrap Ownership

| Option | Description | Selected |
|--------|-------------|----------|
| Minimal bootstrap only | Keep only startup ordering, runtime bootstrap wiring, and calls into extracted modules | |
| Bootstrap + runtime concerns | Keep bootstrap and runtime-oriented concerns in `bootstrap.lua` while moving editor behavior out | ✓ |
| Broader bootstrap | Keep any startup-flag or environment-shaped code there even if it is not plugin-related | |

**User's choice:** Bootstrap + runtime concerns
**Notes:** Scheduled clipboard setup should stay with bootstrap/runtime concerns. Diagnostics placement and runtimepath prepend handling were delegated.

---

## Namespace and Naming

| Option | Description | Selected |
|--------|-------------|----------|
| `lua/story/core/` | Keep extracted modules under a Story-specific core namespace | |
| `lua/story/config/` | Keep extracted modules under a Story-specific config namespace | |
| `lua/story/` flat | Add extracted modules alongside `bootstrap.lua` | |
| Agent proposes the clearest layout | Choose the layout based on readability rather than preset namespace branding | ✓ |

**User's choice:** Agent proposes the clearest layout
**Notes:** There is no need for a `story.*` branded namespace for ordinary config modules. Shared helper naming was delegated. No further naming preference was expressed beyond readability.

---

## Teaching Style

| Option | Description | Selected |
|--------|-------------|----------|
| Keep them instructional | Preserve the Kickstart teaching tone in the new files | |
| Moderate comments | Explain non-obvious choices, but trim repetitive tutorial text | ✓ |
| Lean | Mostly code, only comments where needed | |

**User's choice:** Moderate comments
**Notes:** This is a personal config, so clean internal structure matters more than beginner-oriented forkability. Comment migration details were delegated.

---

## the agent's Discretion

- Diagnostics placement across extracted modules
- Shared helper/runtime module naming
- Runtimepath prepend handling structure
- Exact comment migration strategy during extraction

## Deferred Ideas

None
