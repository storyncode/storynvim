# StoryNvim

## What This Is

This repository is a forkable Neovim configuration based on Kickstart.nvim. It now runs as a modular Lua config with a minimal `init.lua` entrypoint, dedicated startup orchestration under `lua/story/`, always-on editor behavior under `lua/core/`, shipped plugin behavior under `lua/plugins/`, and fork-local extensions under `lua/custom/plugins/`.

## Core Value

The config must stay easy to reason about while moving from one giant startup file to a clean modular structure that preserves current functionality.

## Current State

`v1.0` is shipped and archived. The repo now teaches the same architecture it runs: `init.lua` is a thin bootstrap entrypoint, startup ordering lives in `lua/story/bootstrap.lua`, always-on editor behavior lives in `lua/core/`, shipped plugin specs live in concern-based modules under `lua/plugins/`, `custom.plugins` is the stable extension path, and the README/help surfaces point readers at those ownership boundaries.

## Next Milestone Goals

- Define the next milestone with `/gsd-new-milestone`
- Decide whether to pay down accepted `v1.0` debt first:
  - Backfill Nyquist-compliant validation for Phases 01 and 02
  - Remove the stale README phrase
  - Remove the stale `lua/kickstart/plugins/gitsigns.lua` historical comment
- Decide whether `FUT-01` and `FUT-02` should become active milestone requirements

## Requirements

### Validated

- ✓ Bootstraps `lazy.nvim` and loads a working plugin-based Neovim environment from `init.lua`
- ✓ Provides modern editor defaults, keymaps, autocommands, and diagnostics behavior for daily editing
- ✓ Includes working plugin integrations for Telescope, Treesitter, LSP, completion, formatting, and optional plugin modules under `lua/kickstart/plugins/`
- ✓ Ships with local health checks and user-facing setup documentation in `lua/kickstart/health.lua`, `README.md`, and `doc/kickstart.txt`
- ✓ Phase 1 established a thin `init.lua`, ordered bootstrap module, and dedicated lazy bootstrap helper without breaking headless startup checks — v1.0
- ✓ Phase 2 moved shipped plugin specs into concern-based `lua/plugins` modules and switched bootstrap to `lazy.nvim` imports — v1.0
- ✓ Phase 3 extracted always-on editor options, keymaps, autocommands, and diagnostics into `lua/core/` modules — v1.0
- ✓ Phase 4 preserved parity, kept optional modules compatible, and stabilized `custom.plugins` as the fork-local extension path — v1.0
- ✓ Phase 5 updated the README, help docs, and inline guidance to teach the modular architecture instead of the historical single-file model — v1.0

### Active

None. Define the next milestone before adding new active requirements.

### Out of Scope

- Replacing the current plugin stack with an unrelated distribution or opinionated framework
- Large feature expansion unrelated to the structural migration
- Cross-editor support or packaging this as a general-purpose Neovim distro

## Context

This is a brownfield Neovim configuration derived from Kickstart.nvim. `v1.0` finished the structural migration to a modular runtime without turning the project into a feature rewrite. The next planning cycle can now decide whether to focus on validation debt, cleanup polish, or new behavior beyond the migration itself.

## Constraints

- **Tech stack**: Neovim Lua config with `lazy.nvim`
- **Compatibility**: Existing behavior should remain intact
- **Scope discipline**: Structural clarity and maintainability still matter more than plugin churn
- **Documentation**: Repo guidance must continue to match the shipped runtime shape

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Treat this as a brownfield refactor rather than a greenfield rewrite | Existing config behavior already works and should be preserved | ✓ Good |
| Target a minimal `init.lua` plus modular Lua imports | This directly matched the desired end state and reduced future maintenance cost | ✓ Good |
| Use a `lua/plugins`-style plugin import layout | It was the clearest structural replacement for the inline plugin table | ✓ Good |
| Route documentation by ownership boundary | Once the runtime became modular, docs needed to point readers to the correct files | ✓ Good |
| Keep planning docs in git | The migration benefited from persistent project memory across phases | ✓ Good |

## Milestone History

- `v1.0` shipped on 2026-04-12. See [v1.0-ROADMAP.md](/Users/danieldavies/dev/nvim/storynvim/.planning/milestones/v1.0-ROADMAP.md:1) and [v1.0-REQUIREMENTS.md](/Users/danieldavies/dev/nvim/storynvim/.planning/milestones/v1.0-REQUIREMENTS.md:1).

---
*Last updated: 2026-04-12 after v1.0 milestone completion*
