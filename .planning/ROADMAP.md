# Roadmap: StoryNvim

## Overview

This roadmap migrates the repo from a monolithic Kickstart-style `init.lua` to a structured Neovim config with a minimal entrypoint, dedicated core modules, and a `lua/plugins` import layout. The sequence front-loads safe bootstrap work, then separates plugin registration from core editor behavior, then validates parity and documentation so the repo ends in a cleaner but still trustworthy state.

## Phases

- [x] **Phase 1: Bootstrap Skeleton** - Introduce the minimal entrypoint and module loading foundation (completed 2026-04-11)
- [x] **Phase 2: Plugin Import Layout** - Move plugin declarations into a structured `lua/plugins` system (completed 2026-04-11)
- [x] **Phase 3: Core Module Extraction** - Split options, keymaps, and autocommands into dedicated modules (completed 2026-04-11)
- [x] **Phase 4: Compatibility and Cleanup** - Reconcile optional modules and verify behavioral parity (completed 2026-04-11)
- [ ] **Phase 5: Documentation Refresh** - Update repo guidance to reflect the new modular architecture

## Phase Details

### Phase 1: Bootstrap Skeleton
**Goal**: Create the new startup structure so `init.lua` becomes a thin bootstrap layer that delegates to modules without breaking startup behavior.
**Depends on**: Nothing (first phase)
**Requirements**: [BOOT-01, BOOT-02, BOOT-03]
**Success Criteria** (what must be TRUE):
  1. `init.lua` only contains essential early startup work plus module entrypoints
  2. `lazy.nvim` still bootstraps correctly after the new module boundaries are introduced
  3. Startup order for leader keys, globals, and runtimepath remains correct
**Plans**: 3 plans

Plans:
- [x] `01-01-PLAN.md` — Define the target startup/module layout and move the ordered startup body into a bootstrap module
- [x] `01-02-PLAN.md` — Reduce `init.lua` to the minimal entrypoint and verify the real startup path still boots cleanly
- [x] `01-03-PLAN.md` — Extract the risky `lazy.nvim` bootstrap into a shared helper and rerun the smoke suite

### Phase 2: Plugin Import Layout
**Goal**: Replace the inline plugin table with a `lua/plugins`-style import system organized by concern.
**Depends on**: Phase 1
**Requirements**: [PLUG-01, PLUG-02]
**Success Criteria** (what must be TRUE):
  1. Active plugin specs are no longer embedded as one monolithic table in `init.lua`
  2. Plugin declarations are grouped into coherent files under the new plugin namespace
  3. `lazy.nvim` loads plugin specs through imports instead of requiring manual inline maintenance
**Plans**: 3 plans

Plans:
- [x] `02-01-PLAN.md` — Create the editor and Telescope concern modules under `lua/plugins/`
- [x] `02-02-PLAN.md` — Create the LSP, coding, and UI concern modules under `lua/plugins/`
- [x] `02-03-PLAN.md` — Switch `lazy.setup` to `import = 'plugins'`, remove the inline plugin table, and rerun smoke checks

### Phase 3: Core Module Extraction
**Goal**: Move non-plugin editor behavior out of `init.lua` into dedicated modules with clear boundaries.
**Depends on**: Phase 2
**Requirements**: [CORE-01, CORE-02, CORE-03]
**Success Criteria** (what must be TRUE):
  1. Editor options live in dedicated modules
  2. Keymaps and autocommands live in dedicated modules
  3. The startup path clearly shows where to modify core editor behavior versus plugin behavior
**Plans**: 3 plans

Plans:
- [x] `03-01-PLAN.md` — Extract always-on options and diagnostics into dedicated `lua/core/` modules while keeping runtime clipboard/bootstrap behavior in `lua/story/bootstrap.lua`
- [x] `03-02-PLAN.md` — Extract always-on global keymaps into `lua/core/keymaps.lua` and keep plugin-local mappings in plugin ownership
- [x] `03-03-PLAN.md` — Extract always-on autocmds into `lua/core/autocmds.lua` and finalize bootstrap as the explicit core-versus-runtime orchestrator

### Phase 4: Compatibility and Cleanup
**Goal**: Ensure the new structure preserves existing behavior and that optional modules fit the new architecture cleanly.
**Depends on**: Phase 3
**Requirements**: [PLUG-03, PAR-01, PAR-02, PAR-03]
**Success Criteria** (what must be TRUE):
  1. Optional modules and health checks still work under the new structure
  2. Core interactive workflows like Telescope, LSP, completion, formatting, and Treesitter still behave as before
  3. The refactor leaves no dead paths or duplicate startup logic behind
**Plans**: 3 plans

Plans:
- [x] `04-01-PLAN.md` — Activate `custom.plugins` as the stable extension path while keeping `kickstart.plugins.*` as legacy/example opt-ins
- [x] `04-02-PLAN.md` — Add a reusable parity assertion module and block cleanup on interactive workflow sign-off
- [x] `04-03-PLAN.md` — Remove only proven duplicate bootstrap logic and finalize the post-parity startup boundaries

### Phase 5: Documentation Refresh
**Goal**: Rewrite project guidance so the repo teaches and documents the modular layout that now exists.
**Depends on**: Phase 4
**Requirements**: [DOC-01, DOC-02]
**Success Criteria** (what must be TRUE):
  1. `README.md` explains the modular structure and where to customize it
  2. The repo no longer describes itself as intentionally single-file
  3. Any relevant inline guidance or help docs align with the new startup architecture
**Plans**: 2 plans

Plans:
- [ ] `05-01-PLAN.md` — Rewrite `README.md` around the modular architecture and current customization surfaces
- [ ] `05-02-PLAN.md` — Refresh help and inline guidance, then regenerate `doc/tags`

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3 → 4 → 5

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Bootstrap Skeleton | 3/3 | Complete | 2026-04-11 |
| 2. Plugin Import Layout | 3/3 | Complete | 2026-04-11 |
| 3. Core Module Extraction | 3/3 | Complete | 2026-04-11 |
| 4. Compatibility and Cleanup | 3/3 | Complete | 2026-04-11 |
| 5. Documentation Refresh | 0/2 | Not started | - |
