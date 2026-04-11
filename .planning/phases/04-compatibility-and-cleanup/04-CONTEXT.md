# Phase 4: Compatibility and Cleanup - Context

**Gathered:** 2026-04-11
**Status:** Ready for planning

<domain>
## Phase Boundary

Ensure the new modular structure preserves existing behavior, reconcile optional/example modules with that structure, and remove dead or duplicate startup paths without expanding the feature set. This phase covers compatibility for optional modules and health checks, parity validation for core interactive workflows, and cleanup of obsolete runtime paths. Documentation rewrites and broad branding changes belong to later phases.

</domain>

<decisions>
## Implementation Decisions

### Optional Module Entry Points
- **D-01:** `lua/custom/plugins/` remains the stable user extension path in the modular architecture.
- **D-02:** `lua/kickstart/plugins/` should remain available only as legacy/example modules rather than a first-class active plugin namespace.
- **D-03:** Phase 4 may add compatibility support for optional/example modules if needed, but should not require users to move custom plugin files out of `lua/custom/plugins/`.

### Legacy Branding And Health Surface
- **D-04:** Phase 4 should keep existing Kickstart-facing module names and user-visible health messages rather than renaming them now.
- **D-05:** Branding cleanup is explicitly deferred; compatibility work should not introduce avoidable path or message churn in health-related surfaces.

### Parity Sign-Off Bar
- **D-06:** Phase 4 requires strict parity for the core interactive workflows called out in the roadmap, not just startup sanity.
- **D-07:** Telescope, LSP attach behavior, completion, formatting, Treesitter, health checks, and optional plugin-module behavior are all phase-blocking validation targets.

### Cleanup Strictness
- **D-08:** Cleanup should remove only clearly dead or duplicate runtime/startup paths.
- **D-09:** Harmless transitional scaffolding or comments can remain if removing them is not necessary to eliminate duplication or obsolete behavior.

### the agent's Discretion
- Exact compatibility mechanism for legacy/example `kickstart.plugins` modules, provided `custom.plugins` remains the stable user path and no new active shipped-plugin source of truth is introduced outside `lua/plugins/`.
- Exact validation approach for proving parity across the required interactive workflows.
- Which comments or transitional guidance count as harmless scaffolding versus dead or duplicate behavior that must be removed.

</decisions>

<specifics>
## Specific Ideas

- Keep Kickstart names and messages in place for now rather than folding branding cleanup into this compatibility phase.
- Treat strict behavioral parity as the standard for completion, not a best-effort extra.
- Favor conservative cleanup over broad polish so regressions remain attributable and scope stays tight.

</specifics>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Planning And Scope
- `.planning/PROJECT.md` — Project vision and constraints: brownfield refactor, preserve behavior, avoid broad churn.
- `.planning/REQUIREMENTS.md` — Phase-linked requirements, especially `PLUG-03`, `PAR-01`, `PAR-02`, and `PAR-03`.
- `.planning/ROADMAP.md` — Phase 4 goal, success criteria, and plan breakdown for compatibility, parity validation, and cleanup.
- `.planning/STATE.md` — Current project position and the recorded startup-order regression risk.
- `.planning/phases/02-plugin-import-layout/02-CONTEXT.md` — Prior decisions preserving `kickstart.plugins` and `custom.plugins` as non-primary namespaces.
- `.planning/phases/03-core-module-extraction/03-CONTEXT.md` — Prior decisions about bootstrap ownership, runtime-sensitive concerns, and clear module boundaries.

### Active Runtime Code
- `init.lua` — Thin entrypoint, retained Kickstart-facing framing, and current leader/global setup.
- `lua/story/bootstrap.lua` — Current runtime orchestrator, `lazy.setup(...)` import wiring, optional module guidance comments, and potential duplicate runtimepath handling.
- `lua/story/bootstrap/lazy.lua` — Lazy bootstrap helper whose startup behavior must remain compatible.
- `lua/kickstart/health.lua` — Existing health-check surface and Kickstart-facing diagnostic messaging retained for compatibility.

### Active Workflow Modules
- `lua/plugins/telescope.lua` — Telescope behavior and LSP-bound picker mappings that need parity validation.
- `lua/plugins/lsp.lua` — LSP attach behavior, Mason setup, and formatting integration that need parity validation.
- `lua/plugins/coding.lua` — Completion and Treesitter behavior that need parity validation.
- `lua/plugins/editor.lua` — Core editor-adjacent plugin behavior including gitsigns/which-key baseline setup.
- `lua/plugins/ui.lua` — Start-plugin UI behavior that should remain unaffected by cleanup.

### Optional And Extension Module Paths
- `lua/kickstart/plugins/debug.lua` — Legacy/example optional module with deeper dependency wiring that must still fit the architecture cleanly.
- `lua/kickstart/plugins/lint.lua` — Legacy/example optional module with autocommand behavior that needs compatibility consideration.
- `lua/kickstart/plugins/gitsigns.lua` — Legacy/example optional module that layers onto an already-active shipped plugin.
- `lua/kickstart/plugins/autopairs.lua` — Legacy/example optional plugin entrypoint.
- `lua/kickstart/plugins/indent_line.lua` — Legacy/example optional plugin entrypoint.
- `lua/kickstart/plugins/neo-tree.lua` — Legacy/example optional plugin entrypoint.
- `lua/custom/plugins/init.lua` — Stable user-owned plugin extension namespace that must remain intact.

### Codebase Guidance
- `.planning/codebase/CONVENTIONS.md` — Existing Lua/module conventions and comment expectations.
- `.planning/codebase/STRUCTURE.md` — Historical structure map showing legacy namespaces and extension points.
- `.planning/codebase/INTEGRATIONS.md` — External-tool and health-related integration surfaces relevant to parity checks.
- `.planning/codebase/STACK.md` — Runtime and dependency context for Neovim, `lazy.nvim`, LSP, formatting, Telescope, and Treesitter.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `lua/story/bootstrap.lua`: Central compatibility seam where imports, runtimepath setup, and optional-module guidance currently converge.
- `lua/story/bootstrap/lazy.lua`: Isolated plugin-manager bootstrap that reduces risk when validating startup parity.
- `lua/kickstart/health.lua`: Existing health provider that can remain stable while the internal architecture continues to shift.
- `lua/kickstart/plugins/*.lua`: Concrete legacy/example optional module set that Phase 4 must reconcile without confusing the active shipped layout.
- `lua/custom/plugins/init.lua`: Existing extension hook that already matches the preferred user-customization story.

### Established Patterns
- Active shipped plugins now load from `spec = { { import = 'plugins' } }` in `lua/story/bootstrap.lua`; Phase 4 should not reintroduce a competing active plugin source.
- Startup still flows through `init.lua` into `require('story.bootstrap').setup()`, so parity work must preserve that ordered path.
- The codebase prefers readable Lua and conservative structural refactors over broad redesign.
- Optional behaviors are often demonstrated through commented examples and dedicated module files rather than always-on defaults.

### Integration Points
- Compatibility decisions for optional modules connect directly to the commented guidance and import wiring in `lua/story/bootstrap.lua`.
- Health compatibility connects to `lua/kickstart/health.lua` and any module-path expectations around `kickstart` naming.
- Parity validation must cover the workflows implemented across `lua/plugins/telescope.lua`, `lua/plugins/lsp.lua`, `lua/plugins/coding.lua`, `lua/plugins/editor.lua`, and the legacy optional modules under `lua/kickstart/plugins/`.
- Cleanup work must distinguish real dead/duplicate runtime paths from instructional scaffolding that can remain until documentation refresh.

</code_context>

<deferred>
## Deferred Ideas

- Broad StoryNvim rebranding of module names, health output, and user-facing messages — defer to a later phase rather than mixing it into compatibility work.
- Broad polish-oriented trimming of comments or instructional scaffolding that is not clearly dead or duplicate behavior.

</deferred>

---

*Phase: 04-compatibility-and-cleanup*
*Context gathered: 2026-04-11*
