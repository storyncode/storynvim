# StoryNvim

## What This Is

This repository is a forkable Neovim configuration based on Kickstart.nvim. It now runs as a modular Lua config with a minimal `init.lua` entrypoint, dedicated startup orchestration under `lua/story/`, always-on editor behavior under `lua/core/`, shipped plugin behavior under `lua/plugins/`, and fork-local extensions under `lua/custom/plugins/`.

## Core Value

The config must stay easy to reason about while moving from one giant startup file to a clean modular structure that preserves current functionality.

## Requirements

### Validated

- ✓ Bootstraps `lazy.nvim` and loads a working plugin-based Neovim environment from `init.lua` — existing
- ✓ Provides modern editor defaults, keymaps, autocommands, and diagnostics behavior for daily editing — existing
- ✓ Includes working plugin integrations for Telescope, Treesitter, LSP, completion, formatting, and optional plugin modules under `lua/kickstart/plugins/` — existing
- ✓ Ships with local health checks and user-facing setup documentation in `lua/kickstart/health.lua`, `README.md`, and `doc/kickstart.txt` — existing
- ✓ Phase 1 established a thin `init.lua`, ordered bootstrap module, and dedicated lazy bootstrap helper without breaking headless startup checks — validated in Phase 1: Bootstrap Skeleton
- ✓ Phase 2 moved shipped plugin specs into concern-based `lua/plugins` modules and switched bootstrap to `lazy.nvim` imports — validated in Phase 2: Plugin Import Layout
- ✓ Phase 3 extracted always-on editor options, keymaps, autocommands, and diagnostics into `lua/core/` modules — validated in Phase 3: Core Module Extraction
- ✓ Phase 4 preserved parity, kept optional modules compatible, and stabilized `custom.plugins` as the fork-local extension path — validated in Phase 4: Compatibility and Cleanup
- ✓ Phase 5 updated the README, help docs, and inline guidance to teach the modular architecture instead of the historical single-file model — validated in Phase 5: Documentation Refresh

### Active

None currently. Milestone v1.0 is complete.

### Out of Scope

- Replacing the current plugin stack with an unrelated distribution or opinionated framework — the goal is structural refactoring, not a full product reset
- Large feature expansion unrelated to the migration — extra plugins or workflow changes would blur whether the refactor preserved behavior
- Cross-editor support or packaging this as a general-purpose Neovim distro — this remains a personal/forkable Neovim config

## Context

This is a brownfield Neovim configuration derived from Kickstart.nvim. The migration finished with a cleaner module system that keeps the config understandable without drifting into a feature rewrite: `init.lua` is a thin entrypoint, `lua/story/` owns startup orchestration, `lua/core/` owns always-on editor behavior, `lua/plugins/` owns shipped plugin specs, `lua/custom/plugins/` is the stable fork-local extension path, and `lua/kickstart/plugins/` remains compatibility/example-only.

## Constraints

- **Tech stack**: Neovim Lua config with `lazy.nvim` — the refactor should work with the existing runtime model instead of inventing a new configuration system
- **Compatibility**: Existing behavior should remain intact — the migration should not silently break keymaps, plugin loading, or health checks
- **Scope discipline**: Structural refactor first — plugin churn and unrelated customization should be deferred unless required to support the new layout
- **Documentation**: Repo guidance must match reality — once the config is modular, docs cannot keep presenting the project as intentionally single-file

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Treat this as a brownfield refactor rather than a greenfield rewrite | Existing config behavior already works and should be preserved | Phase 1 kept runtime behavior intact while changing structure |
| Target a minimal `init.lua` plus modular Lua imports | This directly matches the desired end state and reduces future maintenance cost | Phase 1 delivered the thin entrypoint plus bootstrap modules |
| Use a `lua/plugins`-style plugin import layout | It is the clearest structural replacement for the current inline plugin table | Phase 2 completed this with concern-based modules and `spec = { { import = 'plugins' } }` |
| Route documentation by ownership boundary | Once the runtime was modular, docs needed to point readers to the correct files without reviving the single-file mental model | Phase 5 aligned `README.md`, `doc/kickstart.txt`, and inline comments around `lua/core/`, `lua/plugins/`, and `lua/custom/plugins/` |
| Keep planning docs in git | The migration is multi-phase and benefits from persistent project memory | — Pending |

## Current State

Phases 1 through 5 are complete. The repo now teaches the same architecture it runs: `init.lua` is a thin bootstrap entrypoint, startup ordering lives in `lua/story/bootstrap.lua`, always-on editor behavior lives in `lua/core/`, shipped plugin specs live in concern-based modules under `lua/plugins/`, `custom.plugins` is the stable extension path, and the README/help surfaces point readers at those ownership boundaries.

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd-transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd-complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-04-11 after Phase 5 completion*
