# Phase 03: Core Module Extraction - Research

**Researched:** 2026-04-11
**Domain:** Neovim core-config modularization for always-on editor behavior
**Confidence:** HIGH

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
- **D-01:** The split does not need to be rigidly limited to exactly `options`, `keymaps`, and `autocmds`; planning may introduce additional small modules when they improve clarity. [VERIFIED: .planning/phases/03-core-module-extraction/03-CONTEXT.md]
- **D-02:** A shared helper or runtime-oriented module is acceptable if more than one extracted module needs it. [VERIFIED: .planning/phases/03-core-module-extraction/03-CONTEXT.md]
- **D-03:** The final structure should still make `options`, `keymaps`, and `autocmds` recognizable, but exact roadmap wording is less important than a clear module layout. [VERIFIED: .planning/phases/03-core-module-extraction/03-CONTEXT.md]
- **D-04:** `lua/story/bootstrap.lua` may remain responsible for bootstrap and runtime-oriented concerns rather than shrinking to a purely trivial dispatcher. [VERIFIED: .planning/phases/03-core-module-extraction/03-CONTEXT.md]
- **D-05:** The scheduled clipboard setup should stay with bootstrap/runtime concerns rather than moving into a plain options module. [VERIFIED: .planning/phases/03-core-module-extraction/03-CONTEXT.md]
- **D-06:** The extracted module layout should be chosen for clarity rather than preserving a `story.*` branded namespace. [VERIFIED: .planning/phases/03-core-module-extraction/03-CONTEXT.md]
- **D-07:** Generic Neovim config concepts are preferred over Story-specific naming for extracted core modules. [VERIFIED: .planning/phases/03-core-module-extraction/03-CONTEXT.md]
- **D-08:** Extracted modules should use moderate comments: preserve explanations for non-obvious behavior, but trim tutorial-style commentary that is no longer useful for a personal config. [VERIFIED: .planning/phases/03-core-module-extraction/03-CONTEXT.md]
- **D-09:** Readability should prioritize a clean internal structure for personal maintenance rather than maximizing beginner-oriented forkability. [VERIFIED: .planning/phases/03-core-module-extraction/03-CONTEXT.md]

### Claude's Discretion
- Exact module names and directory layout, provided they are clear and do not overfit the current `story.*` namespace. [VERIFIED: .planning/phases/03-core-module-extraction/03-CONTEXT.md]
- Whether diagnostics config and its quickfix keymap stay together or split across modules. [VERIFIED: .planning/phases/03-core-module-extraction/03-CONTEXT.md]
- Whether comments should move verbatim, be condensed, or be selectively rewritten during extraction. [VERIFIED: .planning/phases/03-core-module-extraction/03-CONTEXT.md]
- How to treat the runtimepath prepend helper structurally, as long as startup behavior remains intact. [VERIFIED: .planning/phases/03-core-module-extraction/03-CONTEXT.md]

### Deferred Ideas (OUT OF SCOPE)
- None — discussion stayed within phase scope. [VERIFIED: .planning/phases/03-core-module-extraction/03-CONTEXT.md]
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| CORE-01 | Editor options are defined in dedicated modules instead of inline in `init.lua` | Move static always-on options from `lua/story/bootstrap.lua` into `lua/core/options.lua`, keep startup-critical globals in `init.lua`, and keep the delayed clipboard assignment in bootstrap/runtime so ordering stays explicit. [VERIFIED: init.lua] [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: .planning/phases/03-core-module-extraction/03-CONTEXT.md] [CITED: https://neovim.io/doc/user/lua-guide.html#lua-guide-options] |
| CORE-02 | Keymaps are defined in dedicated modules instead of inline in `init.lua` | Move global non-plugin mappings into `lua/core/keymaps.lua`; keep plugin-specific and buffer-local mappings inside their plugin modules so ownership stays clear. [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: lua/plugins/lsp.lua] [VERIFIED: lua/plugins/telescope.lua] [CITED: https://neovim.io/doc/user/lua-guide.html#lua-guide-mappings] |
| CORE-03 | Autocommands and other startup helpers are defined in dedicated modules instead of inline in `init.lua` | Move always-on non-plugin autocommands into `lua/core/autocmds.lua`, keep runtimepath/lazy bootstrap in `lua/story/bootstrap.lua`, and do not absorb plugin-local autocmds from `lua/plugins/*`. [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: lua/plugins/lsp.lua] [VERIFIED: lua/plugins/coding.lua] [VERIFIED: .planning/phases/03-core-module-extraction/03-CONTEXT.md] [CITED: https://neovim.io/doc/user/lua-guide.html#lua-guide-autocommands] |
</phase_requirements>

## Summary

Phase 3 is a structural extraction from `lua/story/bootstrap.lua`, not a behavior rewrite. Today that file still owns all always-on editor options, basic global keymaps, the yank highlight autocmd, diagnostic configuration, runtimepath prepend logic, and the `lazy.nvim` setup call. `init.lua` is already minimal and only sets the early globals plus `require('story.bootstrap').setup()`, so the phase should preserve that startup shape instead of re-expanding `init.lua`. [VERIFIED: init.lua] [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: .planning/REQUIREMENTS.md]

The cleanest plan is to keep `lua/story/bootstrap.lua` as the runtime orchestrator, introduce a generic `lua/core/` namespace for always-on editor behavior, and extract by ownership: `options`, `keymaps`, and `autocmds` remain first-class modules, with an additional small `diagnostics` module recommended because the current diagnostic config is neither an option block nor an autocmd block. Startup-critical globals such as `vim.g.mapleader` and `vim.g.maplocalleader` should stay in `init.lua` because `lazy.nvim` documents `init`-time global setup as startup-sensitive and the repo already treats these globals as pre-bootstrap requirements. [VERIFIED: init.lua] [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: .planning/phases/03-core-module-extraction/03-CONTEXT.md] [CITED: https://neovim.io/doc/user/lua-guide.html#lua-guide-mappings] [CITED: https://lazy.folke.io/spec]

**Primary recommendation:** Keep `init.lua` unchanged except for comment cleanup, keep `lua/story/bootstrap.lua` as the ordered runtime entrypoint, extract always-on editor behavior into `lua/core/options.lua`, `lua/core/diagnostics.lua`, `lua/core/keymaps.lua`, and `lua/core/autocmds.lua`, and leave plugin-local keymaps/autocmds in `lua/plugins/*`. [VERIFIED: init.lua] [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: lua/plugins/lsp.lua] [VERIFIED: lua/plugins/telescope.lua] [VERIFIED: .planning/phases/03-core-module-extraction/03-CONTEXT.md]

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| Neovim Lua runtime | Local environment `NVIM v0.12.1`; repo floor is `0.11+` | Hosts the config, Lua module loading, options, keymaps, autocmds, diagnostics, and headless validation | The repo already targets Neovim Lua APIs directly and the local runtime satisfies the repo's own health requirement. [VERIFIED: local command `nvim --version`] [VERIFIED: lua/kickstart/health.lua] |
| `vim.opt` plus `vim.o` | Built into Neovim 0.11+ | Define options in Lua modules | Neovim documents `vim.opt` as the most convenient Lua API for options and `vim.o` as the direct variable-like form. Use `vim.opt` for table-like options and `vim.o` for scalars to match current code and docs. [VERIFIED: lua/story/bootstrap.lua] [CITED: https://neovim.io/doc/user/lua-guide.html#lua-guide-options] |
| `vim.keymap.set` | Built into Neovim 0.11+ | Define global keymaps in Lua modules | Neovim documents `vim.keymap.set()` as the standard mapping API and it already matches the repo's current style. [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: lua/plugins/lsp.lua] [CITED: https://neovim.io/doc/user/lua-guide.html#lua-guide-mappings] |
| `vim.api.nvim_create_autocmd` and `vim.api.nvim_create_augroup` | Built into Neovim 0.11+ | Define always-on autocmds in Lua modules | Neovim documents Lua autocmd creation through the API, and the repo already uses named augroups with `clear = true`. [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: lua/plugins/lsp.lua] [CITED: https://neovim.io/doc/user/lua-guide.html#lua-guide-autocommands] |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| `lua/story/bootstrap.lua` | Current repo module | Runtime orchestrator for ordered startup | Keep this as the single ordered path for runtimepath prepend, delayed clipboard setup, lazy bootstrap, and `lazy.setup(...)`. [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: .planning/phases/03-core-module-extraction/03-CONTEXT.md] |
| `folke/lazy.nvim` | Bootstrapped from `stable` branch at runtime | Plugin manager entrypoint that Phase 3 must leave untouched behaviorally | Keep `lazy.setup({ spec = { { import = 'plugins' } } }, ...)` in bootstrap; Phase 3 is not the place to rework plugin loading. [VERIFIED: lua/story/bootstrap/lazy.lua] [VERIFIED: lua/story/bootstrap.lua] [CITED: https://lazy.folke.io/spec] |
| `lua/plugins/*.lua` concern modules | Current repo pattern | Existing home for plugin-owned behavior | Use these as the ownership boundary: plugin-local mappings and autocmds stay there. [VERIFIED: lua/plugins/editor.lua] [VERIFIED: lua/plugins/lsp.lua] [VERIFIED: lua/plugins/telescope.lua] |
| Headless `nvim` smoke checks | Verified locally | Fast regression check in a repo with no test harness | This phase can be validated through headless assertions for options, keymaps, and autocmd registration. [VERIFIED: local command `nvim --headless -u ./init.lua "+lua local map=vim.fn.maparg('<C-h>', 'n', false, true); assert(vim.o.number == true and vim.o.signcolumn == 'yes'); assert(type(map) == 'table' and map.rhs == '<C-w><C-h>'); local ac=vim.api.nvim_get_autocmds({group='kickstart-highlight-yank'}); assert(#ac > 0)" +qa`] [VERIFIED: .planning/codebase/TESTING.md] |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| `lua/core/options.lua`, `lua/core/keymaps.lua`, `lua/core/autocmds.lua`, `lua/core/diagnostics.lua` | Keep everything in `lua/story/bootstrap.lua` with comment headings | That preserves behavior but fails the phase goal because ownership remains concentrated in the bootstrap file. [VERIFIED: .planning/ROADMAP.md] |
| Keep startup-critical globals in `init.lua` | Move all globals into `lua/core/globals.lua` | A globals module can work only if required before bootstrap, but it makes the entrypoint less obviously startup-sensitive. Keeping leader globals in `init.lua` is clearer and safer. [VERIFIED: init.lua] [VERIFIED: .planning/REQUIREMENTS.md] [CITED: https://lazy.folke.io/spec] |
| Keep diagnostics in its own small module | Fold diagnostics config into `keymaps.lua` | Folding is possible, but diagnostics is a separate runtime concern and the current quickfix keymap plus config are easier to reason about together. [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: .planning/phases/03-core-module-extraction/03-CONTEXT.md] |

**Version verification / currency checks:**
```bash
nvim --version | head -1
```

## Architecture Patterns

### Recommended Project Structure
```text
init.lua                     # Early globals only: mapleader, maplocalleader, have_nerd_font, bootstrap entrypoint
lua/
├── core/
│   ├── options.lua         # Static always-on editor options
│   ├── diagnostics.lua     # vim.diagnostic.config + diagnostic quickfix mapping if kept together
│   ├── keymaps.lua         # Global non-plugin mappings
│   └── autocmds.lua        # Always-on non-plugin autocmds and augroups
├── plugins/                # Plugin-owned keymaps/autocmds remain here
└── story/
    └── bootstrap.lua       # Ordered runtime orchestration
```

### Pattern 1: Bootstrap As Orchestrator
**What:** `lua/story/bootstrap.lua` should stay responsible for ordered startup work and call extracted core modules in a readable sequence. [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: .planning/phases/03-core-module-extraction/03-CONTEXT.md]
**When to use:** For runtimepath prepend, delayed clipboard setup, lazy bootstrap, lazy UI options, and the sequence that wires core modules before plugin setup. [VERIFIED: lua/story/bootstrap.lua]
**Example:**
```lua
local M = {}

function M.setup()
  require('core.options').setup()
  require('core.diagnostics').setup()
  require('core.keymaps').setup()
  require('core.autocmds').setup()

  vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

  local source = debug.getinfo(1, 'S').source:sub(2)
  local config_root = vim.fs.dirname(vim.fs.dirname(vim.fs.dirname(source)))
  vim.opt.rtp:prepend(config_root)

  require('story.bootstrap.lazy').setup()
  require('lazy').setup({
    spec = { { import = 'plugins' } },
  }, {
    ui = {
      icons = vim.g.have_nerd_font and {} or {},
    },
  })
end

return M
```

### Pattern 2: Use `vim.opt` For Table-Like Options
**What:** Prefer `vim.opt` for table-like options such as `listchars`; use `vim.o` for simple scalar options to minimize churn from the current code. [VERIFIED: lua/story/bootstrap.lua] [CITED: https://neovim.io/doc/user/lua-guide.html#lua-guide-options]
**When to use:** In `lua/core/options.lua`.
**Example:**
```lua
local M = {}

function M.setup()
  vim.o.number = true
  vim.o.mouse = 'a'
  vim.o.showmode = false
  vim.o.breakindent = true
  vim.o.undofile = true
  vim.o.ignorecase = true
  vim.o.smartcase = true
  vim.o.signcolumn = 'yes'
  vim.o.updatetime = 250
  vim.o.timeoutlen = 300
  vim.o.splitright = true
  vim.o.splitbelow = true
  vim.o.list = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
  vim.o.inccommand = 'split'
  vim.o.cursorline = true
  vim.o.scrolloff = 10
  vim.o.confirm = true
end

return M
```

### Pattern 3: Keep Ownership Boundaries Hard
**What:** Always-on editor behavior belongs in `lua/core/*`; plugin-owned behavior stays in `lua/plugins/*`. [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: lua/plugins/lsp.lua] [VERIFIED: lua/plugins/telescope.lua]
**When to use:** During plan scoping and file moves.
**Example:**
```lua
-- core/keymaps.lua
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })

-- plugins/lsp.lua keeps buffer-local LSP maps inside LspAttach
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    vim.keymap.set('n', 'grn', vim.lsp.buf.rename, { buffer = event.buf, desc = 'LSP: [R]e[n]ame' })
  end,
})
```

### Anti-Patterns to Avoid
- **Moving leader globals into late bootstrap code:** `vim.g.mapleader` and `vim.g.maplocalleader` must stay before plugin loading. [VERIFIED: init.lua] [VERIFIED: .planning/REQUIREMENTS.md]
- **Mixing plugin-owned behavior into core modules:** Do not pull `LspAttach`, Telescope LSP picker mappings, or plugin-specific `FileType` autocmds into `lua/core/*`. [VERIFIED: lua/plugins/lsp.lua] [VERIFIED: lua/plugins/telescope.lua] [VERIFIED: lua/plugins/coding.lua]
- **Moving delayed clipboard setup into plain options:** The user explicitly kept it as a runtime/bootstrap concern because it is scheduled for startup-time reasons. [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: .planning/phases/03-core-module-extraction/03-CONTEXT.md]
- **Creating a generic helper framework for tiny modules:** The current codebase favors local, readable modules over abstraction layers. [VERIFIED: .planning/codebase/CONVENTIONS.md]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Core-module loader | Custom recursive directory loader or dynamic require registry | Explicit `require('core.<module>').setup()` calls in bootstrap | Explicit ordering is the main risk in this phase; a dynamic loader hides that order. [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: .planning/STATE.md] |
| Option abstraction layer | Custom wrapper around `vim.o` / `vim.opt` | Native Neovim Lua APIs | Neovim already provides the documented APIs, including table support and append/prepend/remove semantics. [CITED: https://neovim.io/doc/user/lua-guide.html#lua-guide-options] |
| Keymap DSL | Homemade table-driven mapper | Plain `vim.keymap.set()` calls | The current keymap set is small and static; indirection would reduce clarity. [VERIFIED: lua/story/bootstrap.lua] [CITED: https://neovim.io/doc/user/lua-guide.html#lua-guide-mappings] |
| Autocmd wrapper framework | Custom helper around augroups and autocmd registration | `vim.api.nvim_create_augroup()` + `vim.api.nvim_create_autocmd()` | The repo already uses the native API directly and the phase only needs one always-on autocmd today. [VERIFIED: lua/story/bootstrap.lua] [CITED: https://neovim.io/doc/user/lua-guide.html#lua-guide-autocommands] |

**Key insight:** The planning risk is sequencing and ownership, not API complexity. The best Phase 3 plan is explicit, boring module extraction with minimal behavioral edits. [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: .planning/STATE.md]

## Runtime State Inventory

| Category | Items Found | Action Required |
|----------|-------------|-----------------|
| Stored data | None — verified by repo grep and phase scope. This phase moves Lua source only and does not rename persisted keys, collections, or schemas. [VERIFIED: codebase grep] [VERIFIED: .planning/phases/03-core-module-extraction/03-CONTEXT.md] | Code edit only; no data migration task should be planned. [VERIFIED: .planning/ROADMAP.md] |
| Live service config | None — no external UI-managed service config is referenced by this phase's core extraction work. [VERIFIED: codebase grep] | No action. [VERIFIED: .planning/ROADMAP.md] |
| OS-registered state | None — no launchd/systemd/pm2/task registrations are part of this Neovim config refactor. [VERIFIED: codebase grep] | No action. [VERIFIED: .planning/ROADMAP.md] |
| Secrets/env vars | None — no env-var name changes or secret-key lookups are involved in the extracted core behavior. [VERIFIED: codebase grep] | No action. [VERIFIED: .planning/ROADMAP.md] |
| Build artifacts | None blocking — runtime modules are loaded from the repo on startup; no generated artifact rename is required for this phase. [VERIFIED: codebase grep] | Code edit only. [VERIFIED: .planning/ROADMAP.md] |

## Common Pitfalls

### Pitfall 1: Breaking Startup Order While “Cleaning Up”
**What goes wrong:** Core modules are extracted, but leader globals or runtime setup now happen too late and plugin behavior changes subtly. [VERIFIED: init.lua] [VERIFIED: .planning/STATE.md]
**Why it happens:** This phase touches the only ordered startup path and can accidentally move pre-plugin work behind `lazy.setup(...)`. [VERIFIED: lua/story/bootstrap.lua]
**How to avoid:** Keep `init.lua` responsible for early globals, keep `lua/story/bootstrap.lua` responsible for startup sequencing, and make module calls explicit in order. [VERIFIED: init.lua] [VERIFIED: lua/story/bootstrap.lua]
**Warning signs:** `init.lua` grows extra imports, or `lua/story/bootstrap.lua` no longer reads top-to-bottom as runtime setup followed by plugin setup. [VERIFIED: init.lua] [VERIFIED: lua/story/bootstrap.lua]

### Pitfall 2: Pulling Plugin Behavior Into Core
**What goes wrong:** Phase 3 starts moving `LspAttach` logic, Telescope mappings, or plugin-local `FileType` autocmds into `lua/core/*`. [VERIFIED: lua/plugins/lsp.lua] [VERIFIED: lua/plugins/telescope.lua] [VERIFIED: lua/plugins/coding.lua]
**Why it happens:** The repo uses the same Neovim APIs in both core and plugin code, so it is easy to split by API rather than ownership. [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: lua/plugins/lsp.lua]
**How to avoid:** Move only always-on non-plugin behavior from bootstrap; leave plugin-owned behavior where the plugin is configured. [VERIFIED: .planning/phases/03-core-module-extraction/03-CONTEXT.md] [VERIFIED: lua/plugins/lsp.lua]
**Warning signs:** A core module starts requiring plugin modules or knows about plugin-specific events like `LspAttach`. [VERIFIED: lua/plugins/lsp.lua]

### Pitfall 3: Forcing Everything Into Exactly Three Files
**What goes wrong:** Diagnostics, runtime helpers, or comment cleanup become awkward because the plan tries to fit everything into only `options`, `keymaps`, and `autocmds`. [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: .planning/phases/03-core-module-extraction/03-CONTEXT.md]
**Why it happens:** The roadmap names three plan areas, but the phase decisions explicitly allow extra small modules. [VERIFIED: .planning/ROADMAP.md] [VERIFIED: .planning/phases/03-core-module-extraction/03-CONTEXT.md]
**How to avoid:** Keep the required three concepts recognizable, but add `diagnostics.lua` when it improves ownership clarity. [VERIFIED: .planning/phases/03-core-module-extraction/03-CONTEXT.md]
**Warning signs:** A module contains unrelated blocks only because they did not fit anywhere else. [VERIFIED: lua/story/bootstrap.lua]

### Pitfall 4: Rewriting Comments Instead of Extracting Behavior
**What goes wrong:** The change set grows with tutorial rewrites and wording churn, making parity review harder. [VERIFIED: init.lua] [VERIFIED: lua/story/bootstrap.lua]
**Why it happens:** The original Kickstart-derived file is comment-heavy, and extraction invites editorial cleanup. [VERIFIED: init.lua] [VERIFIED: lua/story/bootstrap.lua]
**How to avoid:** Keep non-obvious rationale, trim only redundant tutorial text, and defer broad doc work to Phase 5. [VERIFIED: .planning/phases/03-core-module-extraction/03-CONTEXT.md] [VERIFIED: .planning/ROADMAP.md]
**Warning signs:** Large diffs dominated by prose changes rather than module boundaries. [VERIFIED: .planning/ROADMAP.md]

## Code Examples

Verified patterns from official docs and the current repo:

### Scalar And Table Options
```lua
-- Source: https://neovim.io/doc/user/lua-guide.html#lua-guide-options
local M = {}

function M.setup()
  vim.o.number = true
  vim.o.splitright = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
end

return M
```

### Global Keymaps
```lua
-- Source: https://neovim.io/doc/user/lua-guide.html#lua-guide-mappings
local M = {}

function M.setup()
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
  vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
end

return M
```

### Named Augroup Autocmd
```lua
-- Source: https://neovim.io/doc/user/lua-guide.html#lua-guide-autocommands
local M = {}

function M.setup()
  local group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true })
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = group,
    callback = function() vim.hl.on_yank() end,
  })
end

return M
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| One monolithic startup file | Thin `init.lua` plus bootstrap and plugin concern modules | Repo migrated in Phases 1 and 2 on 2026-04-11. [VERIFIED: .planning/STATE.md] | Phase 3 should finish the same structural move for always-on core behavior instead of inventing a new architecture. [VERIFIED: .planning/ROADMAP.md] |
| Inline plugin spec table in bootstrap | `lazy.nvim` import-driven `lua/plugins` layout | Completed in Phase 2 on 2026-04-11. [VERIFIED: .planning/STATE.md] [VERIFIED: lua/story/bootstrap.lua] | Core extraction must now respect that plugin ownership already has a home. [VERIFIED: lua/plugins/editor.lua] [VERIFIED: lua/plugins/lsp.lua] |
| Single file mixes runtime, core config, and plugins | Ordered bootstrap plus focused modules by concern | Current repo direction as of 2026-04-11. [VERIFIED: .planning/PROJECT.md] [VERIFIED: .planning/ROADMAP.md] | The remaining work is extraction and parity, not new infrastructure. [VERIFIED: .planning/PROJECT.md] |

**Deprecated/outdated:**
- Treating `lua/story/bootstrap.lua` as the long-term home for all always-on editor behavior is now outdated relative to the roadmap; it should become the runtime orchestrator, not the ownership bucket for every core setting. [VERIFIED: .planning/ROADMAP.md] [VERIFIED: lua/story/bootstrap.lua]

## Assumptions Log

All claims in this research were verified or cited — no user confirmation needed.

## Open Questions (RESOLVED)

1. **Should diagnostics live in `keymaps.lua` or a separate `diagnostics.lua`?**
   - Resolution: Use a dedicated `lua/core/diagnostics.lua`.
   - Basis: D-01 permits additional small modules when they improve clarity, and the diagnostics config plus `<leader>q` quickfix mapping form a coherent always-on diagnostics concern distinct from general keymaps. [VERIFIED: .planning/phases/03-core-module-extraction/03-CONTEXT.md] [VERIFIED: lua/story/bootstrap.lua]
   - Planning consequence: Plan `03-01` owns `lua/core/diagnostics.lua`, while Plan `03-02` keeps `lua/core/keymaps.lua` limited to the remaining global non-plugin mappings. [VERIFIED: .planning/phases/03-core-module-extraction/03-01-PLAN.md] [VERIFIED: .planning/phases/03-core-module-extraction/03-02-PLAN.md]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| Neovim | Runtime validation and headless smoke checks | ✓ | `NVIM v0.12.1` | — [VERIFIED: local command `nvim --version`] |
| Git | Existing lazy bootstrap path and repo operations | ✓ | `git version 2.53.0` | — [VERIFIED: local command `git --version`] |
| `rg` | Fast codebase verification and health expectations | ✓ | `ripgrep 15.1.0` | Use `grep` if needed, but `rg` is present. [VERIFIED: local command `rg --version`] |
| `make` | Optional plugin build steps already in repo | ✓ | `GNU Make 3.81` | — [VERIFIED: local command `make --version`] |
| `unzip` | Existing health expectations | ✓ | `UnZip 6.00` | — [VERIFIED: local command `unzip -v`] |
| `stylua` | Formatting gate in CI | ✗ | — | Use CI as the formatting gate or install locally before implementation if local formatting is needed. [VERIFIED: local command `stylua --version`] [VERIFIED: .github/workflows/stylua.yml] |

**Missing dependencies with no fallback:**
- None for planning or implementation of this phase. [VERIFIED: local command audit]

**Missing dependencies with fallback:**
- `stylua` is missing locally, but the phase can still be implemented and smoke-tested; formatting can rely on CI or a later local install. [VERIFIED: local command `stylua --version`] [VERIFIED: .planning/codebase/TESTING.md]

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | None detected; validation is headless Neovim smoke checks plus manual spot checks. [VERIFIED: .planning/codebase/TESTING.md] |
| Config file | None — no test runner config exists. [VERIFIED: .planning/codebase/TESTING.md] |
| Quick run command | `nvim --headless -u ./init.lua "+lua local map=vim.fn.maparg('<C-h>', 'n', false, true); assert(vim.o.number == true and vim.o.signcolumn == 'yes'); assert(type(map) == 'table' and map.rhs == '<C-w><C-h>'); local ac=vim.api.nvim_get_autocmds({group='kickstart-highlight-yank'}); assert(#ac > 0)" +qa` [VERIFIED: local command] |
| Full suite command | `nvim --headless -u ./init.lua "+checkhealth kickstart" +qa` [VERIFIED: local command `nvim --headless -u ./init.lua "+checkhealth kickstart" +qa`] |

### Phase Requirements → Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| CORE-01 | Extracted options still apply at startup | smoke | `nvim --headless -u ./init.lua "+lua assert(vim.o.number == true and vim.o.signcolumn == 'yes' and vim.o.scrolloff == 10)" +qa` | ✅ uses existing runtime |
| CORE-02 | Global non-plugin keymaps still exist | smoke | `nvim --headless -u ./init.lua "+lua local esc=vim.fn.maparg('<Esc>', 'n', false, true); local left=vim.fn.maparg('<C-h>', 'n', false, true); assert(esc.rhs == '<Cmd>nohlsearch<CR>' or esc.rhs == '<cmd>nohlsearch<CR>'); assert(left.rhs == '<C-w><C-h>')" +qa` | ✅ uses existing runtime |
| CORE-03 | Always-on autocmds still register and bootstrap helpers still work | smoke | `nvim --headless -u ./init.lua "+lua local ac=vim.api.nvim_get_autocmds({group='kickstart-highlight-yank'}); assert(#ac > 0)" "+checkhealth kickstart" +qa` | ✅ uses existing runtime |

### Sampling Rate
- **Per task commit:** Run the quick smoke command.
- **Per wave merge:** Run the full `checkhealth` command.
- **Phase gate:** Full headless startup plus targeted smoke assertions green before `/gsd-verify-work`.

### Wave 0 Gaps
- None — existing headless runtime commands are enough for this refactor phase, even though there is no formal test framework. [VERIFIED: .planning/codebase/TESTING.md]

## Security Domain

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|-----------------|
| V2 Authentication | no | Not applicable; local editor config, no auth flow. [VERIFIED: .planning/PROJECT.md] |
| V3 Session Management | no | Not applicable; no session or token management in phase scope. [VERIFIED: .planning/PROJECT.md] |
| V4 Access Control | no | Not applicable; local config refactor only. [VERIFIED: .planning/PROJECT.md] |
| V5 Input Validation | yes | Keep direct values explicit in Lua modules; avoid dynamic loading or string-built command registries for core extraction. [VERIFIED: lua/story/bootstrap.lua] |
| V6 Cryptography | no | No cryptographic behavior in phase scope. [VERIFIED: .planning/PROJECT.md] |

### Known Threat Patterns for Neovim core-config refactors

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Startup path regression from reordered code | Tampering | Keep explicit bootstrap ordering and verify with headless startup commands. [VERIFIED: .planning/STATE.md] [VERIFIED: local command] |
| Accidental dynamic module loading from untrusted paths | Elevation of Privilege | Do not introduce dynamic require walkers; use explicit module imports in repo-owned paths. [VERIFIED: lua/story/bootstrap.lua] |
| Silent behavior drift during structural refactor | Tampering | Preserve existing settings verbatim where possible and validate options/keymaps/autocmds directly. [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: local command] |

## Sources

### Primary (HIGH confidence)
- `init.lua` - verified early globals and bootstrap entrypoint.
- `lua/story/bootstrap.lua` - verified current options, diagnostics, keymaps, autocmds, runtimepath prepend, and `lazy.setup(...)`.
- `lua/story/bootstrap/lazy.lua` - verified `lazy.nvim` stable-branch bootstrap.
- `lua/plugins/editor.lua` - verified plugin concern-module style.
- `lua/plugins/lsp.lua` - verified plugin-local keymaps and autocmd ownership pattern.
- `lua/plugins/telescope.lua` - verified plugin-local keymaps and autocmd ownership pattern.
- `.planning/phases/03-core-module-extraction/03-CONTEXT.md` - verified locked decisions and discretion areas.
- `.planning/REQUIREMENTS.md` - verified `CORE-01`, `CORE-02`, and `CORE-03`.
- `.planning/ROADMAP.md` - verified phase goal, success criteria, and plan slots.
- `.planning/STATE.md` - verified startup-regression risk and current phase state.
- `.planning/codebase/CONVENTIONS.md` - verified comment and module-style expectations.
- `.planning/codebase/TESTING.md` - verified no test framework and current validation surface.
- https://neovim.io/doc/user/lua-guide.html#lua-guide-options - checked current official Lua option guidance.
- https://neovim.io/doc/user/lua-guide.html#lua-guide-mappings - checked current official keymap guidance.
- https://neovim.io/doc/user/lua-guide.html#lua-guide-autocommands - checked current official autocmd guidance.
- https://lazy.folke.io/spec - checked current official lazy.nvim startup/config semantics.

### Secondary (MEDIUM confidence)
- https://neovim.io/doc/user/lua-guide - verified current page contents via search snippet and guide overview.

### Tertiary (LOW confidence)
- None.

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - confirmed from local runtime, current repo code, and official Neovim docs.
- Architecture: HIGH - driven by locked phase decisions plus the actual startup path in code.
- Pitfalls: HIGH - grounded in the repo's current ownership boundaries and validated headless commands.

**Research date:** 2026-04-11
**Valid until:** 2026-05-11
