# Architecture

**Analysis Date:** 2026-04-11

## Pattern Overview

**Overall:** Single-entrypoint Neovim configuration with declarative plugin-spec composition.

**Key Characteristics:**
- `init.lua` is the runtime root and contains almost all active behavior, including editor options, keymaps, autocommands, plugin bootstrap, and plugin configuration.
- `require('lazy').setup(...)` in `init.lua` composes the system from `LazySpec` tables rather than from application services or domain modules.
- Optional modularity exists as importable plugin-spec modules under `lua/kickstart/plugins/` and a user-owned extension namespace under `lua/custom/plugins/`.

## Layers

**Bootstrap Layer:**
- Purpose: Start Neovim configuration, set globals early, and ensure the plugin manager is available.
- Location: `init.lua`
- Contains: Leader key setup, UI/editor options, initial keymaps, basic autocommands, `lazy.nvim` clone/bootstrap logic.
- Depends on: Neovim Lua API (`vim.*`), external `git` for first-run bootstrap.
- Used by: Neovim on startup when this repo is loaded as the config directory.

**Core Configuration Layer:**
- Purpose: Define baseline editor behavior before or alongside plugin initialization.
- Location: `init.lua`
- Contains: Options like line numbers and clipboard, diagnostic defaults, terminal/window navigation keymaps, yank-highlighting autocmd.
- Depends on: Neovim builtin subsystems such as diagnostics, keymaps, autocommands, and options.
- Used by: Every buffer/session after startup.

**Plugin Composition Layer:**
- Purpose: Register the active plugin graph, lazy-loading triggers, dependency edges, and plugin-local configuration.
- Location: `init.lua`
- Contains: The `require('lazy').setup({ ... })` plugin list, inline `opts`, inline `config` callbacks, lazy-loading events/commands/keys, optional import hooks.
- Depends on: `lazy.nvim` and each declared plugin.
- Used by: `lazy.nvim` during plugin resolution and loading.

**Plugin Extension Layer:**
- Purpose: Provide additional plugin specs that can be imported into the main plugin graph.
- Location: `lua/kickstart/plugins/*.lua`
- Contains: Self-contained `LazySpec` modules for debugging, linting, tree browser, extra git bindings, autopairs, and indent guides.
- Depends on: `lazy.nvim` module import semantics and the plugin APIs each file configures.
- Used by: `init.lua` when corresponding `require 'kickstart.plugins.*'` lines are uncommented.

**User Customization Layer:**
- Purpose: Reserve a conflict-free namespace for repo consumers to add their own specs.
- Location: `lua/custom/plugins/init.lua`
- Contains: An empty `LazySpec` return table intended for user additions or more files in the same directory.
- Depends on: `lazy.nvim` import semantics.
- Used by: `init.lua` when `{ import = 'custom.plugins' }` is uncommented.

**Operational Health Layer:**
- Purpose: Expose environment checks through Neovim's `:checkhealth` mechanism.
- Location: `lua/kickstart/health.lua`
- Contains: Version validation and external executable checks for `git`, `make`, `unzip`, and `rg`.
- Depends on: `vim.health`, `vim.version`, `vim.fn.executable`, and `vim.uv` / `vim.loop`.
- Used by: `:checkhealth kickstart.nvim` style health runs.

**Documentation Layer:**
- Purpose: Publish user-facing installation and help content for the config.
- Location: `README.md`, `doc/kickstart.txt`
- Contains: Installation instructions, rationale for the single-file design, and a Vim help tag entry.
- Depends on: GitHub rendering for `README.md` and Vim help runtime for `doc/kickstart.txt`.
- Used by: Humans onboarding to the config and Neovim help tooling.

## Data Flow

**Startup Flow:**

1. Neovim loads `init.lua` from the config root.
2. `init.lua` sets globals that must exist before plugin loading, including `vim.g.mapleader`, `vim.g.maplocalleader`, and `vim.g.have_nerd_font` in `init.lua`.
3. `init.lua` applies core options, diagnostics, keymaps, and basic autocommands in place.
4. `init.lua` checks for `lazy.nvim` under `vim.fn.stdpath('data') .. '/lazy/lazy.nvim'`, clones it with `git clone` if missing, and prepends it to runtimepath.
5. `require('lazy').setup({ ... })` registers the plugin spec graph from `init.lua`, plus any optional imports from `lua/kickstart/plugins/*.lua` or `lua/custom/plugins/*.lua` when uncommented.
6. `lazy.nvim` loads eager plugins immediately and defers event/key/cmd-triggered plugins until their triggers fire.
7. Plugin `config` functions create secondary autocommands and keymaps, such as Telescope’s `LspAttach` handlers in `init.lua` and Treesitter’s `FileType` handler in `init.lua`.

**LSP Flow:**

1. `init.lua` registers the `neovim/nvim-lspconfig` plugin and its Mason-related dependencies.
2. The plugin `config` block in `init.lua` creates an `LspAttach` autocmd that adds buffer-local keymaps and optional highlight/inlay-hint behavior.
3. The `servers` table in `init.lua` defines server-specific config, currently including `stylua` and `lua_ls`.
4. `mason-tool-installer` receives the server names via `ensure_installed`.
5. Each entry is activated through `vim.lsp.config(name, server)` and `vim.lsp.enable(name)`.
6. When a language server attaches to a buffer, the earlier `LspAttach` callback wires user interactions for that buffer.

**Syntax and Buffer Enhancement Flow:**

1. `nvim-treesitter` is loaded eagerly from `init.lua` with `lazy = false`.
2. The plugin ensures a base parser set and then registers a `FileType` autocmd.
3. On filetype detection, the callback maps filetype to Treesitter language, checks installed parsers, optionally installs missing parsers, then starts Treesitter and sets `indentexpr`.

**Optional Module Activation Flow:**

1. A maintainer uncomments one of the `require 'kickstart.plugins.*'` lines in `init.lua` or the `{ import = 'custom.plugins' }` line.
2. `lazy.nvim` resolves that module through `lua/kickstart/plugins/*.lua` or `lua/custom/plugins/*.lua`.
3. The module returns a `LazySpec` table.
4. `lazy.nvim` merges that spec into the plugin graph and activates it using the spec’s events, keys, opts, and config.

**State Management:**
- Global configuration state is held directly in Neovim globals and options from `init.lua`, especially `vim.g.*`, `vim.o`, `vim.opt`, and buffer/window options mutated inside callbacks.
- There is no separate application state layer, persistence layer, or custom in-memory domain model.

## Key Abstractions

**LazySpec Modules:**
- Purpose: Represent plugin declarations as data tables with optional behavior hooks.
- Examples: `lua/kickstart/plugins/debug.lua`, `lua/kickstart/plugins/lint.lua`, `lua/kickstart/plugins/neo-tree.lua`, `lua/custom/plugins/init.lua`
- Pattern: Return a Lua table typed as `LazySpec`, optionally including `dependencies`, `event`, `keys`, `opts`, and `config`.

**Autocommand-Oriented Feature Wiring:**
- Purpose: Attach behavior in response to Neovim lifecycle events instead of central controllers.
- Examples: Yank highlighting in `init.lua`, LSP binding in `init.lua`, linting in `lua/kickstart/plugins/lint.lua`, Treesitter filetype handling in `init.lua`
- Pattern: `vim.api.nvim_create_autocmd(...)` with named augroups and inline callbacks.

**Inline Config Closures:**
- Purpose: Keep plugin behavior physically near the plugin declaration.
- Examples: Telescope, LSP, Conform, Blink, Tokyonight, Mini, and Treesitter blocks in `init.lua`
- Pattern: `config = function() ... end` or `opts = { ... }` embedded directly inside the plugin spec.

**Import Namespace Boundaries:**
- Purpose: Separate upstream Kickstart examples from end-user customization.
- Examples: `lua/kickstart/plugins/*.lua` for sample optional modules, `lua/custom/plugins/init.lua` for local additions
- Pattern: Module resolution through `require 'kickstart.plugins.NAME'` or `{ import = 'custom.plugins' }`.

**Health Check Provider:**
- Purpose: Package environment diagnostics as a callable Neovim health module.
- Examples: `lua/kickstart/health.lua`
- Pattern: Return a table exposing `check = function() ... end`.

## Entry Points

**Primary Startup Entry Point:**
- Location: `init.lua`
- Triggers: Neovim startup when this repository is used as the active config directory.
- Responsibilities: Initialize globals, options, keymaps, autocommands, bootstrap `lazy.nvim`, register plugin specs, and define optional extension hooks.

**Health Entry Point:**
- Location: `lua/kickstart/health.lua`
- Triggers: Neovim health subsystem when the Kickstart health check is requested.
- Responsibilities: Report Neovim version status, print system information, and validate required executables.

**Documentation Entry Point:**
- Location: `doc/kickstart.txt`
- Triggers: Vim help lookup for `*kickstart.nvim*`.
- Responsibilities: Expose a minimal help page inside the Neovim help system.

**Optional Plugin Module Entry Points:**
- Location: `lua/kickstart/plugins/debug.lua`, `lua/kickstart/plugins/gitsigns.lua`, `lua/kickstart/plugins/indent_line.lua`, `lua/kickstart/plugins/lint.lua`, `lua/kickstart/plugins/neo-tree.lua`, `lua/kickstart/plugins/autopairs.lua`, `lua/custom/plugins/init.lua`
- Triggers: Module import from the `require('lazy').setup(...)` spec list in `init.lua`.
- Responsibilities: Supply additional plugin specs without changing the runtime model.

## Error Handling

**Strategy:** Fail fast during bootstrap, otherwise rely on Neovim/plugin defaults with light defensive checks around optional runtime capabilities.

**Patterns:**
- Bootstrap failure is explicit: `init.lua` raises `error(...)` if cloning `lazy.nvim` fails.
- Optional behavior is guarded with checks such as `pcall(...)` for Telescope extension loading in `init.lua`.
- Capability-dependent behavior is gated with method checks like `client:supports_method(...)` in the LSP `LspAttach` callback in `init.lua`.
- Runtime availability is checked before activation, such as `vim.fn.executable('make')` for Telescope FZF native and `vim.treesitter.language.add(language)` for Treesitter attach.

## Cross-Cutting Concerns

**Logging:** No dedicated logging layer is implemented. Health output uses `vim.health.*` in `lua/kickstart/health.lua`.

**Validation:** Validation is procedural and local to each subsystem, such as environment checks in `lua/kickstart/health.lua`, LSP capability checks in `init.lua`, and parser/tool availability checks in `init.lua`.

**Authentication:** Not applicable. The codebase is a local editor configuration and does not implement application authentication.

**Extensibility:** Extend behavior by adding or importing more `LazySpec` modules under `lua/custom/plugins/` and enabling the import hook in `init.lua`.

**Runtime Boundary:** This repo configures the editor only. Persistent plugin data is stored outside the repo under Neovim standard paths like `stdpath('data')`, not inside the project tree.

---

*Architecture analysis: 2026-04-11*
