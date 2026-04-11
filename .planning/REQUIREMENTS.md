# Requirements: StoryNvim

**Defined:** 2026-04-11
**Core Value:** The config must stay easy to reason about while moving from one giant startup file to a clean modular structure that preserves current functionality.

## v1 Requirements

### Bootstrap

- [x] **BOOT-01**: `init.lua` contains only minimal startup orchestration for leader setup, runtime bootstrap, and module entrypoints
- [x] **BOOT-02**: `lazy.nvim` bootstrap remains functional after the refactor
- [x] **BOOT-03**: Module loading order preserves required early globals and runtimepath setup

### Plugin Structure

- [x] **PLUG-01**: Plugin declarations are moved out of the monolithic `init.lua` into a `lua/plugins`-style import structure
- [x] **PLUG-02**: Plugin specs are grouped by concern so related plugins can be found and edited without scanning the whole config
- [ ] **PLUG-03**: Existing optional plugin modules remain compatible or are migrated consistently into the new structure

### Core Config

- [ ] **CORE-01**: Editor options are defined in dedicated modules instead of inline in `init.lua`
- [ ] **CORE-02**: Keymaps are defined in dedicated modules instead of inline in `init.lua`
- [ ] **CORE-03**: Autocommands and other startup helpers are defined in dedicated modules instead of inline in `init.lua`

### Behavioral Parity

- [ ] **PAR-01**: Core editing behavior remains unchanged from the user perspective after the migration
- [ ] **PAR-02**: LSP, completion, formatting, Treesitter, and Telescope still load and work after the migration
- [ ] **PAR-03**: Health checks and optional plugin modules still load correctly after the migration

### Documentation

- [ ] **DOC-01**: Repository documentation describes the modular layout and where to customize the config
- [ ] **DOC-02**: The repo no longer presents the single-file layout as the intended architecture for this fork

## v2 Requirements

### Future Cleanup

- **FUT-01**: Add automated smoke checks or tests for critical Neovim startup behavior
- **FUT-02**: Revisit optional module boundaries once the main migration is stable

## Out of Scope

| Feature | Reason |
|---------|--------|
| Swapping to a different plugin manager | Not required for the structural migration |
| Broad plugin churn unrelated to modularization | Increases regression risk and obscures refactor goals |
| Turning the repo into a full Neovim distribution | The project goal is maintainable personal structure, not distro design |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| BOOT-01 | Phase 1 | Complete |
| BOOT-02 | Phase 1 | Complete |
| BOOT-03 | Phase 1 | Complete |
| PLUG-01 | Phase 2 | Complete |
| PLUG-02 | Phase 2 | Complete |
| PLUG-03 | Phase 4 | Pending |
| CORE-01 | Phase 3 | Pending |
| CORE-02 | Phase 3 | Pending |
| CORE-03 | Phase 3 | Pending |
| PAR-01 | Phase 4 | Pending |
| PAR-02 | Phase 4 | Pending |
| PAR-03 | Phase 4 | Pending |
| DOC-01 | Phase 5 | Pending |
| DOC-02 | Phase 5 | Pending |

**Coverage:**
- v1 requirements: 14 total
- Mapped to phases: 14
- Unmapped: 0 ✓

---
*Requirements defined: 2026-04-11*
*Last updated: 2026-04-11 after Phase 1 completion*
