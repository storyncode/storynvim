# StoryNvim

## What This Is

This repository is a forkable Neovim configuration based on Kickstart.nvim. Today it works as a mostly single-file config, and the current project is to migrate it into a structured Lua module layout with a minimal `init.lua` entrypoint while preserving the existing behavior and the repo's value as an understandable personal config base.

## Core Value

The config must stay easy to reason about while moving from one giant startup file to a clean modular structure that preserves current functionality.

## Requirements

### Validated

- ✓ Bootstraps `lazy.nvim` and loads a working plugin-based Neovim environment from `init.lua` — existing
- ✓ Provides modern editor defaults, keymaps, autocommands, and diagnostics behavior for daily editing — existing
- ✓ Includes working plugin integrations for Telescope, Treesitter, LSP, completion, formatting, and optional plugin modules under `lua/kickstart/plugins/` — existing
- ✓ Ships with local health checks and user-facing setup documentation in `lua/kickstart/health.lua`, `README.md`, and `doc/kickstart.txt` — existing
- ✓ Phase 1 established a thin `init.lua`, ordered bootstrap module, and dedicated lazy bootstrap helper without breaking headless startup checks — validated in Phase 1: Bootstrap Skeleton

### Active

- [ ] Move plugin registration to a `lua/plugins`-style import system so plugin specs are grouped by concern instead of embedded inline in the entrypoint
- [ ] Split editor settings, keymaps, autocommands, and plugin-related helper logic into coherent modules with clear ownership
- [ ] Preserve existing behavior during the migration so the refactor does not regress startup, keymaps, LSP, formatting, Telescope, or optional modules
- [ ] Update documentation so the repo explains the modular structure instead of teaching the single-file layout

### Out of Scope

- Replacing the current plugin stack with an unrelated distribution or opinionated framework — the goal is structural refactoring, not a full product reset
- Large feature expansion unrelated to the migration — extra plugins or workflow changes would blur whether the refactor preserved behavior
- Cross-editor support or packaging this as a general-purpose Neovim distro — this remains a personal/forkable Neovim config

## Context

This is a brownfield Neovim configuration derived from Kickstart.nvim. The current architecture concentrates bootstrap code, core editor behavior, plugin specs, and plugin configuration in `init.lua`, with only a small set of optional modules already living under `lua/kickstart/plugins/` and `lua/custom/plugins/`. The migration target is a cleaner module system that follows the common `lua/plugins` import pattern while keeping the config understandable, preserving behavior, and avoiding a refactor that turns into a feature rewrite.

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
| Use a `lua/plugins`-style plugin import layout | It is the clearest structural replacement for the current inline plugin table | — Pending |
| Keep planning docs in git | The migration is multi-phase and benefits from persistent project memory | — Pending |

## Current State

Phase 1 is complete. `init.lua` is now a thin bootstrap entrypoint, startup ordering lives in `lua/story/bootstrap.lua`, and the risky `lazy.nvim` clone/runtimepath logic is isolated in `lua/story/bootstrap/lazy.lua`. The next step is moving the inline plugin table into a `lua/plugins` import layout.

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
*Last updated: 2026-04-11 after Phase 1 completion*
