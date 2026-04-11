# Phase 3: Core Module Extraction - Context

**Gathered:** 2026-04-11
**Status:** Ready for planning

<domain>
## Phase Boundary

Move non-plugin editor behavior out of `lua/story/bootstrap.lua` into dedicated modules with clear boundaries. This phase covers extraction of options, keymaps, autocommands, and closely related always-on editor behavior while preserving the current startup path. Plugin behavior changes, optional module reconciliation, broader parity cleanup, and documentation rewrites belong to later phases.

</domain>

<decisions>
## Implementation Decisions

### Module Boundaries
- **D-01:** The split does not need to be rigidly limited to exactly `options`, `keymaps`, and `autocmds`; planning may introduce additional small modules when they improve clarity.
- **D-02:** A shared helper or runtime-oriented module is acceptable if more than one extracted module needs it.
- **D-03:** The final structure should still make `options`, `keymaps`, and `autocmds` recognizable, but exact roadmap wording is less important than a clear module layout.

### Bootstrap Ownership
- **D-04:** `lua/story/bootstrap.lua` may remain responsible for bootstrap and runtime-oriented concerns rather than shrinking to a purely trivial dispatcher.
- **D-05:** The scheduled clipboard setup should stay with bootstrap/runtime concerns rather than moving into a plain options module.

### Namespace And Naming
- **D-06:** The extracted module layout should be chosen for clarity rather than preserving a `story.*` branded namespace.
- **D-07:** Generic Neovim config concepts are preferred over Story-specific naming for extracted core modules.

### Teaching Style
- **D-08:** Extracted modules should use moderate comments: preserve explanations for non-obvious behavior, but trim tutorial-style commentary that is no longer useful for a personal config.
- **D-09:** Readability should prioritize a clean internal structure for personal maintenance rather than maximizing beginner-oriented forkability.

### the agent's Discretion
- Exact module names and directory layout, provided they are clear and do not overfit the current `story.*` namespace.
- Whether diagnostics config and its quickfix keymap stay together or split across modules.
- Whether comments should move verbatim, be condensed, or be selectively rewritten during extraction.
- How to treat the runtimepath prepend helper structurally, as long as startup behavior remains intact.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Planning And Scope
- `.planning/PROJECT.md` — Project vision, current migration target, and the requirement to preserve behavior while modularizing.
- `.planning/REQUIREMENTS.md` — Phase-linked requirements for core extraction, especially `CORE-01`, `CORE-02`, and `CORE-03`.
- `.planning/ROADMAP.md` — Phase 3 goal, success criteria, and plan breakdown for options, keymaps, and autocommands extraction.
- `.planning/STATE.md` — Current project position and the recorded startup-regression risk.
- `.planning/phases/02-plugin-import-layout/02-CONTEXT.md` — Prior phase decisions establishing concern-based structure and preserving bootstrap behavior.

### Active Runtime Code
- `init.lua` — Minimal entrypoint, leader setup, and current top-level instructional framing.
- `lua/story/bootstrap.lua` — Current home of the always-on editor behavior being extracted in this phase.
- `lua/story/bootstrap/lazy.lua` — Existing lazy bootstrap helper that Phase 3 must leave compatible.

### Existing Module Patterns
- `lua/plugins/editor.lua` — Example of the new concern-based module layout already used for plugin specs.
- `lua/plugins/lsp.lua` — Another active concern module showing the current modular style for shipped code.
- `.planning/codebase/CONVENTIONS.md` — Repository conventions around comments, module design, and Lua style.
- `.planning/codebase/STRUCTURE.md` — Current structure map showing the repo's historical concentration of always-on behavior.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `lua/story/bootstrap.lua`: Already groups the exact behavior this phase must separate, making it the primary extraction source.
- `lua/story/bootstrap/lazy.lua`: Isolated lazy bootstrap helper that narrows the risk surface by keeping plugin-manager setup separate.
- `lua/plugins/*.lua`: Established modular pattern for concern-based Lua files that planning can mirror for core config extraction.

### Established Patterns
- Startup currently flows from `init.lua` into `require('story.bootstrap').setup()`, so extracted modules should keep that ordered entry path intact.
- The codebase favors readable Lua with explanatory comments and local helpers rather than heavy abstraction.
- Plugin concerns already live in dedicated modules, while always-on editor behavior is still concentrated in `lua/story/bootstrap.lua`.

### Integration Points
- Extracted core modules will be called from `lua/story/bootstrap.lua` unless planning introduces a clearer intermediate runtime module.
- Global settings from `init.lua` (`vim.g.mapleader`, `vim.g.maplocalleader`, `vim.g.have_nerd_font`) must remain compatible with any new module boundaries.
- Diagnostics, keymaps, autocommands, and options all currently interact with the Neovim runtime before or alongside `lazy.setup`, so ordering must stay explicit.

</code_context>

<specifics>
## Specific Ideas

- Flexible module boundaries are preferred over a forced three-file split.
- There is no need to preserve Story-branded naming for ordinary config modules.
- The config is personal, so cleaner internal structure matters more than retaining full Kickstart tutorial density.

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 03-core-module-extraction*
*Context gathered: 2026-04-11*
