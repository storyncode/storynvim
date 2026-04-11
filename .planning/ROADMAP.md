# Roadmap: StoryNvim

## Overview

This roadmap migrates the repo from a monolithic Kickstart-style `init.lua` to a structured Neovim config with a minimal entrypoint, dedicated core modules, and a `lua/plugins` import layout. The sequence front-loads safe bootstrap work, then separates plugin registration from core editor behavior, then validates parity and documentation so the repo ends in a cleaner but still trustworthy state.

## Phases

- [ ] **Phase 1: Bootstrap Skeleton** - Introduce the minimal entrypoint and module loading foundation
- [ ] **Phase 2: Plugin Import Layout** - Move plugin declarations into a structured `lua/plugins` system
- [ ] **Phase 3: Core Module Extraction** - Split options, keymaps, and autocommands into dedicated modules
- [ ] **Phase 4: Compatibility and Cleanup** - Reconcile optional modules and verify behavioral parity
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
- [ ] `01-01-PLAN.md` — Define the target startup/module layout and move the ordered startup body into a bootstrap module
- [ ] `01-02-PLAN.md` — Reduce `init.lua` to the minimal entrypoint and verify the real startup path still boots cleanly
- [ ] `01-03-PLAN.md` — Extract the risky `lazy.nvim` bootstrap into a shared helper and rerun the smoke suite

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
- [ ] 02-01: Create the plugin namespace and move the base plugin list into imported spec files
- [ ] 02-02: Group plugin specs by concern and preserve current lazy-loading/config hooks
- [ ] 02-03: Remove the old inline plugin table once imports fully cover active plugins

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
- [ ] 03-01: Extract options and global settings into core configuration modules
- [ ] 03-02: Extract keymaps into dedicated modules with the same current behavior
- [ ] 03-03: Extract autocommands and helper setup into dedicated modules

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
- [ ] 04-01: Reconcile existing `lua/kickstart/plugins` and `lua/custom/plugins` behavior with the new plugin layout
- [ ] 04-02: Run parity-focused validation and fix regressions in core plugin workflows
- [ ] 04-03: Remove obsolete code paths and finalize the new module boundaries

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
- [ ] 05-01: Update `README.md` to explain the modular layout and customization points
- [ ] 05-02: Refresh any remaining docs or inline guidance that still assume the single-file model

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3 → 4 → 5

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Bootstrap Skeleton | 0/3 | Not started | - |
| 2. Plugin Import Layout | 0/3 | Not started | - |
| 3. Core Module Extraction | 0/3 | Not started | - |
| 4. Compatibility and Cleanup | 0/3 | Not started | - |
| 5. Documentation Refresh | 0/2 | Not started | - |
