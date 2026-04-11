# Phase 2: Plugin Import Layout - Context

**Gathered:** 2026-04-11
**Status:** Ready for planning

<domain>
## Phase Boundary

Replace the active inline plugin specification table with a `lua/plugins`-style import layout organized by concern. This phase covers the structure and import wiring for shipped plugin specs; broader core-module extraction, behavior changes, and documentation rewrites belong to later phases.

</domain>

<decisions>
## Implementation Decisions

### Plugin Namespace Shape
- **D-01:** Active shipped plugin specs should move into a new primary `lua/plugins/` namespace.
- **D-02:** Existing `lua/kickstart/plugins/` and `lua/custom/plugins/` namespaces should remain as example and user-extension spaces rather than becoming the main home for shipped active specs.

### Grouping Strategy
- **D-03:** Plugin spec files should be grouped by concern rather than by load timing or ownership.
- **D-04:** Preferred grouping examples are concern-oriented files such as `editor.lua`, `lsp.lua`, `telescope.lua`, `ui.lua`, and `coding.lua`, with exact boundaries left to planning.

### Optional Module Handling
- **D-05:** Phase 2 should focus on migrating the active inline plugin table, not on broadly relocating existing optional/example modules.
- **D-06:** Existing optional modules under `lua/kickstart/plugins/` and `lua/custom/plugins/` should stay in place unless small compatibility shims are needed for the new import layout.

### Import Style Strictness
- **D-07:** `require('lazy').setup(...)` should treat imports as the primary source of truth for active shipped plugins.
- **D-08:** The old inline plugin table should be removed by the end of Phase 2 rather than leaving a hybrid structure behind.

### the agent's Discretion
- Exact concern boundaries for the new `lua/plugins/*.lua` files, as long as they remain easy to reason about.
- Whether compatibility shims are needed for optional/example modules and how minimal they should be.
- The exact `spec = { ... }` import wiring in `lazy.setup`, provided imports become the canonical source for active shipped plugins.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Planning And Scope
- `.planning/PROJECT.md` — Project vision, active constraints, and the decision to target a `lua/plugins`-style layout without broad plugin churn.
- `.planning/REQUIREMENTS.md` — Phase-linked requirements for plugin modularization, especially `PLUG-01` and `PLUG-02`.
- `.planning/ROADMAP.md` — Phase 2 goal, success criteria, and plan breakdown.
- `.planning/STATE.md` — Current project position and noted regression risk around startup ordering.

### Active Runtime Code
- `lua/story/bootstrap.lua` — Current `require('lazy').setup({ ... })` location and active inline plugin specification table that Phase 2 must replace.
- `lua/story/bootstrap/lazy.lua` — Existing lazy.nvim bootstrap helper that Phase 2 must continue to work with.

### Existing Plugin Module Patterns
- `lua/kickstart/plugins/debug.lua` — Example of the established one-spec-per-file optional plugin module pattern.
- `lua/kickstart/plugins/lint.lua` — Example of a focused plugin module with local config and autocommands.
- `lua/custom/plugins/init.lua` — Existing user-extension namespace that should remain available for fork-local customization.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `lua/kickstart/plugins/*.lua`: Existing examples of LazySpec modules that already match the intended modular pattern.
- `lua/custom/plugins/init.lua`: Existing extension-point module proving that `lazy.nvim` imports are already part of the repo's model.
- `lua/story/bootstrap/lazy.lua`: Isolated lazy bootstrap helper that reduces the migration surface area for Phase 2.

### Established Patterns
- Active runtime configuration currently flows through `lua/story/bootstrap.lua`, which owns the `require('lazy').setup({ ... })` call and the inline plugin table.
- Optional plugin modules return a single `LazySpec` table per file with local `config`, `opts`, `keys`, and `dependencies`.
- The project favors readable, instructional Lua with comments and minimal hidden indirection.

### Integration Points
- The new `lua/plugins/` namespace will connect to `require('lazy').setup({ spec = { ... } })` in `lua/story/bootstrap.lua`.
- Existing optional/example modules in `lua/kickstart/plugins/` and user modules in `lua/custom/plugins/` must remain compatible with the new import-driven layout.
- Phase 2 changes must preserve the startup behavior established by Phase 1 and avoid breaking headless/lazy smoke checks.

</code_context>

<specifics>
## Specific Ideas

- The desired end state is a clear primary `lua/plugins/` namespace for active shipped specs.
- Concern-based grouping is preferred over ownership- or timing-based splitting.
- Existing optional/example namespaces should remain available instead of being absorbed wholesale into the new primary layout.

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 02-plugin-import-layout*
*Context gathered: 2026-04-11*
