# Coding Conventions

**Analysis Date:** 2026-04-11

## Naming Patterns

**Files:**
- Use lowercase Lua module filenames with underscores only when the plugin or concept already uses them, such as `init.lua`, `lua/kickstart/health.lua`, `lua/kickstart/plugins/indent_line.lua`, and `lua/kickstart/plugins/neo-tree.lua`.
- Put optional plugin specs in `lua/kickstart/plugins/*.lua` or `lua/custom/plugins/*.lua`; each file returns a single Lazy plugin spec table, as in `lua/kickstart/plugins/lint.lua` and `lua/custom/plugins/init.lua`.

**Functions:**
- Use `local` functions for reusable helpers and keep names descriptive snake_case, such as `check_version`, `check_external_reqs`, and `treesitter_try_attach` in `lua/kickstart/health.lua` and `init.lua`.
- Use short local helper names only when scoped tightly inside a config callback, such as `map` in `lua/kickstart/plugins/gitsigns.lua` and inside the `LspAttach` callback in `init.lua`.
- Inline anonymous functions are preferred for one-off callbacks in keymaps, autocommands, and plugin config, as shown throughout `init.lua` and `lua/kickstart/plugins/debug.lua`.

**Variables:**
- Use `local` by default. Top-level mutable globals are limited to Neovim globals under `vim.g`, such as `vim.g.mapleader`, `vim.g.maplocalleader`, and `vim.g.have_nerd_font` in `init.lua`.
- Use descriptive snake_case for locals holding API objects or state, for example `lazypath`, `lazyrepo`, `ensure_installed`, `available_parsers`, `highlight_augroup`, and `lint_augroup` in `init.lua` and `lua/kickstart/plugins/lint.lua`.
- Use short aliases only for commonly required plugin modules, such as `local dap = require 'dap'`, `local dapui = require 'dapui'`, `local lint = require 'lint'`, and `local builtin = require 'telescope.builtin'`.

**Types:**
- Annotate plugin specs and option tables with EmmyLua/LuaLS comments before the returned table or config object, for example `---@type LazySpec` in `lua/kickstart/plugins/autopairs.lua` and `---@type conform.setupOpts` in `init.lua`.
- Add targeted `---@diagnostic disable-next-line: missing-fields` comments where third-party plugin option tables are intentionally partial, as in `init.lua`, `lua/kickstart/plugins/debug.lua`, and `lua/kickstart/plugins/gitsigns.lua`.
- Use parameter annotations for local helpers when LuaLS benefits from them, such as `---@param buf integer` and `---@param language string` in `init.lua`.

## Code Style

**Formatting:**
- Formatting is enforced with `stylua` in CI via `.github/workflows/stylua.yml`, which runs `JohnnyMorganz/stylua-action@v4` with `args: --check .`.
- Follow the existing Stylua-shaped layout:
  - Two-space indentation.
  - Single-quoted strings in Lua code, for example throughout `init.lua` and `lua/kickstart/plugins/*.lua`.
  - Omit parentheses for `require`, `setup`, and similar calls when a single string or table argument is passed, such as `require 'lint'`, `require('lazy').setup({ ... })`, and `vim.health.start 'kickstart.nvim'`.
  - Prefer trailing commas in multiline tables, visible across `init.lua` and `lua/kickstart/plugins/debug.lua`.
- Preserve the modeline in `init.lua`: `vim: ts=2 sts=2 sw=2 et`.

**Linting:**
- No standalone repository lint configuration file is present. The only explicit code-quality automation in-repo is Stylua formatting from `.github/workflows/stylua.yml`.
- Lua language-server-oriented type annotations act as the main static-analysis aid, especially in `init.lua` and `lua/kickstart/plugins/*.lua`.

## Import Organization

**Order:**
1. File-level explanatory comments.
2. EmmyLua module/type annotations.
3. `return { ... }` plugin spec table or local helper declarations.
4. `require(...)` calls inside the smallest practical scope, usually inside `config`, `opts.on_attach`, or autocommand callbacks.

**Path Aliases:**
- No path alias system is defined. Modules are required by Lua module path, such as `require 'lint'`, `require 'dap-go'`, `require 'mini.ai'`, and `require 'telescope.builtin'`.
- Local modules follow the filesystem structure directly, for example commented imports in `init.lua` use `require 'kickstart.plugins.debug'` and `require 'kickstart.plugins.lint'`.

## Error Handling

**Patterns:**
- Fail fast for startup-critical operations. `init.lua` raises `error('Error cloning lazy.nvim:\\n' .. out)` when bootstrapping `lazy.nvim` fails.
- Prefer guarded optional behavior with `pcall` when a missing extension should not abort startup, as in `pcall(require('telescope').load_extension, 'fzf')` and `pcall(require('telescope').load_extension, 'ui-select')` in `init.lua`.
- Prefer early returns to avoid nested conditionals, such as the `lua_ls.on_init` guard in `init.lua`, parser attachment guards in `treesitter_try_attach`, and the `vim.bo.modifiable` gate in `lua/kickstart/plugins/lint.lua`.
- Report environment and dependency problems through Neovim health APIs rather than exceptions when the issue is diagnostic, as in `lua/kickstart/health.lua`.

## Logging

**Framework:** `vim.health` for diagnostics; no general runtime logging framework detected.

**Patterns:**
- Use `vim.health.start`, `vim.health.info`, `vim.health.ok`, `vim.health.warn`, and `vim.health.error` for environment checks in `lua/kickstart/health.lua`.
- No `vim.notify` or `print`-based application logging pattern is established in the repository.

## Comments

**When to Comment:**
- Add comments liberally when code is instructional, non-obvious, or intended as a customization guide. `init.lua` is heavily documented and sets the standard for explanatory comments before most configuration blocks.
- Keep short heading comments at the top of plugin modules to state purpose, for example `-- Linting` in `lua/kickstart/plugins/lint.lua` and `-- autopairs` in `lua/kickstart/plugins/autopairs.lua`.
- Use inline comments sparingly to justify non-obvious choices, such as build conditions, keymap intent, and platform-specific behavior in `init.lua` and `lua/kickstart/plugins/debug.lua`.

**JSDoc/TSDoc:**
- Not applicable. The codebase uses EmmyLua/LuaLS annotations instead, especially `---@module`, `---@type`, `---@param`, and diagnostic suppression comments in `init.lua` and `lua/kickstart/plugins/*.lua`.

## Function Design

**Size:**
- Keep helpers small and localized to the config block they serve. Examples include `map` in `lua/kickstart/plugins/gitsigns.lua`, the LSP-local `map` helper in `init.lua`, and `treesitter_try_attach` in `init.lua`.
- Larger configuration flows remain in a single file when they are the primary user-facing reference, as with `init.lua`.

**Parameters:**
- Prefer explicit parameters over free closure state when building reusable helpers, for example `map(mode, l, r, opts)` in `lua/kickstart/plugins/gitsigns.lua` and `treesitter_try_attach(buf, language)` in `init.lua`.
- Callback parameters generally use Neovim event payload naming like `event`, `event2`, `args`, and `bufnr`.

**Return Values:**
- Plugin modules return a single spec table directly, as in every file under `lua/kickstart/plugins/` and `lua/custom/plugins/init.lua`.
- Helper functions return `nil` for guard exits unless the API expects structured data, such as `format_on_save` in `init.lua` returning either `nil` or an options table.

## Module Design

**Exports:**
- Export one Lua table per module. For plugin modules, that table is a Lazy spec; for health integration, `lua/kickstart/health.lua` exports `{ check = function() ... end }`.
- Keep module surface area minimal. Internal helpers stay `local` and are not exported.

**Barrel Files:**
- No barrel-file pattern is used. `lua/custom/plugins/init.lua` acts as an extension point by returning an empty `LazySpec`, not by re-exporting sibling modules.

---

*Convention analysis: 2026-04-11*
