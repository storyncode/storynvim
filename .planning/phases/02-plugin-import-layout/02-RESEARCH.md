# Phase 02: Plugin Import Layout - Research

**Researched:** 2026-04-11
**Domain:** Neovim `lazy.nvim` plugin-spec modularization with `lua/plugins` imports
**Confidence:** HIGH

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
- **D-01:** Active shipped plugin specs should move into a new primary `lua/plugins/` namespace. [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md]
- **D-02:** Existing `lua/kickstart/plugins/` and `lua/custom/plugins/` namespaces should remain as example and user-extension spaces rather than becoming the main home for shipped active specs. [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md]
- **D-03:** Plugin spec files should be grouped by concern rather than by load timing or ownership. [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md]
- **D-04:** Preferred grouping examples are concern-oriented files such as `editor.lua`, `lsp.lua`, `telescope.lua`, `ui.lua`, and `coding.lua`, with exact boundaries left to planning. [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md]
- **D-05:** Phase 2 should focus on migrating the active inline plugin table, not on broadly relocating existing optional/example modules. [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md]
- **D-06:** Existing optional modules under `lua/kickstart/plugins/` and `lua/custom/plugins/` should stay in place unless small compatibility shims are needed for the new import layout. [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md]
- **D-07:** `require('lazy').setup(...)` should treat imports as the primary source of truth for active shipped plugins. [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md]
- **D-08:** The old inline plugin table should be removed by the end of Phase 2 rather than leaving a hybrid structure behind. [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md]

### Claude's Discretion
- Exact concern boundaries for the new `lua/plugins/*.lua` files, as long as they remain easy to reason about. [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md]
- Whether compatibility shims are needed for optional/example modules and how minimal they should be. [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md]
- The exact `spec = { ... }` import wiring in `lazy.setup`, provided imports become the canonical source for active shipped plugins. [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md]

### Deferred Ideas (OUT OF SCOPE)
- None — discussion stayed within phase scope. [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md]
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| PLUG-01 | Plugin declarations are moved out of the monolithic `init.lua` into a `lua/plugins`-style import structure | Use `require('lazy').setup({ spec = { { import = 'plugins' } } }, ...)` in `lua/story/bootstrap.lua`, move active shipped specs into `lua/plugins/*.lua`, and remove the old inline active plugin entries from the bootstrap file before phase close. [VERIFIED: lua/story/bootstrap.lua] [CITED: https://lazy.folke.io/usage/structuring] |
| PLUG-02 | Plugin specs are grouped by concern so related plugins can be found and edited without scanning the whole config | Group the current nine active plugin specs into concern files that mirror the existing commented sections in `lua/story/bootstrap.lua`: `editor.lua`, `telescope.lua`, `lsp.lua`, `ui.lua`, and `treesitter.lua` or `coding.lua` as needed, while keeping each plugin's current `opts`, `config`, `keys`, `event`, and `dependencies` intact. [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md] [CITED: https://lazy.folke.io/usage/structuring] |
</phase_requirements>

## Summary

Phase 2 is a structural migration inside `lua/story/bootstrap.lua`, not a plugin-behavior rewrite. The current runtime still defines all active shipped plugins inline in one `require('lazy').setup({ ... }, { ui = ... })` call, and that inline block currently contains nine top-level active plugin entries: `guess-indent`, `gitsigns`, `which-key`, `telescope`, `nvim-lspconfig`, `conform`, `blink.cmp`, `tokyonight`, `mini.nvim`, and `nvim-treesitter`. Optional/example modules already exist separately under `lua/kickstart/plugins/`, and `lua/custom/plugins/init.lua` already matches the `LazySpec` module return pattern. [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: lua/kickstart/plugins/debug.lua] [VERIFIED: lua/kickstart/plugins/lint.lua] [VERIFIED: lua/custom/plugins/init.lua]

`lazy.nvim` officially supports exactly the target layout for this phase: `require("lazy").setup("plugins")` is equivalent to `require("lazy").setup({ { import = "plugins" } })`, top-level `lua/plugins/*.lua` files are merged automatically, and imported specs can override or extend each other with documented merge behavior for `opts`, `dependencies`, `cmd`, `event`, `ft`, and `keys`. That means the planner does not need a custom loader, a manual `require` fan-out, or a hybrid inline-plus-import transition state. [CITED: https://lazy.folke.io/usage/structuring]

**Primary recommendation:** Replace the inline active spec table in `lua/story/bootstrap.lua` with `spec = { { import = 'plugins' } }`, create concern-oriented files under `lua/plugins/`, copy each current plugin spec mostly verbatim into its new concern file, and keep `lua/kickstart/plugins/` plus `lua/custom/plugins/` untouched unless a tiny compatibility shim is required. [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md] [VERIFIED: lua/story/bootstrap.lua] [CITED: https://lazy.folke.io/usage/structuring]

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| Neovim | Repo health check requires `0.11+`; local environment is `NVIM v0.12.1` | Runtime host for the modular plugin layout and validation commands | The repo already validates against Neovim headless startup, and the local environment exceeds the repo's own health floor. [VERIFIED: lua/kickstart/health.lua] [VERIFIED: local command `nvim --version`] |
| `folke/lazy.nvim` | Repo bootstraps the `stable` branch; latest verified release tag is `v11.17.5` published 2025-11-06 | Plugin manager, import resolver, spec merge engine, lazy-loading | The repo already uses `lazy.nvim`, and upstream documents `lua/plugins` imports as the standard modular pattern. [VERIFIED: lua/story/bootstrap/lazy.lua] [VERIFIED: `git ls-remote --tags --sort='v:refname' https://github.com/folke/lazy.nvim.git | tail -5`] [VERIFIED: GitHub release API `https://api.github.com/repos/folke/lazy.nvim/releases/latest`] [CITED: https://lazy.folke.io/usage/structuring] |
| `lua/plugins/*.lua` LazySpec modules | Current-docs pattern, not a separate package version | Canonical home for active shipped plugin specs | `lazy.nvim` merges specs from the module and any top-level submodules automatically, so this layout is simpler and better cached than manual `require` maintenance. [CITED: https://lazy.folke.io/usage/structuring] |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| `lua/kickstart/plugins/*.lua` | Current repo modules | Example of the repo's existing one-file `LazySpec` pattern | Reuse the same return-table style for the new `lua/plugins/*.lua` files. [VERIFIED: lua/kickstart/plugins/debug.lua] [VERIFIED: lua/kickstart/plugins/lint.lua] |
| `lua/custom/plugins/init.lua` | Current repo module | User-extension namespace kept outside the shipped active namespace | Leave it as a separate customization area instead of folding it into the active shipped plugin tree in Phase 2. [VERIFIED: lua/custom/plugins/init.lua] [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md] |
| Headless Neovim smoke commands | Works locally with `NVIM v0.12.1` | Structural and runtime regression checks without a dedicated test framework | The repo has no test suite directory today, and the Phase 1 validation path already proved the real startup path through `init.lua`. [VERIFIED: local command `nvim --headless -u ./init.lua "+lua assert(vim.g.mapleader == ' ' and vim.g.maplocalleader == ' ' and type(vim.g.have_nerd_font) == 'boolean')" "+Lazy! health" "+checkhealth kickstart" +qa`] [VERIFIED: codebase grep] |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Explicit `spec = { { import = 'plugins' } }` inside `require('lazy').setup({ ... }, opts)` | Shorthand `require('lazy').setup('plugins', opts)` | The shorthand is officially equivalent, but the explicit `spec` table leaves cleaner room for a future second import or a compatibility shim without changing the call shape again. [CITED: https://lazy.folke.io/usage/structuring] |
| Concern files under `lua/plugins/` | One file per plugin | One-file-per-plugin is supported, but the user decisions for this phase prefer concern-oriented grouping over ownership or load timing. [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md] |
| Reuse existing inline plugin bodies with minimal edits | Rewrite plugin configs while moving them | Rewriting configs during the move increases parity risk and makes Phase 2 harder to verify. [VERIFIED: .planning/PROJECT.md] [VERIFIED: .planning/ROADMAP.md] |

**Version verification / currency checks:**
```bash
nvim --version | head -1
git ls-remote --tags --sort='v:refname' https://github.com/folke/lazy.nvim.git | tail -5
curl -s https://api.github.com/repos/folke/lazy.nvim/releases/latest | rg 'tag_name|published_at'
```

## Architecture Patterns

### Recommended Project Structure
```text
lua/
├── plugins/
│   ├── editor.lua      # guess-indent, gitsigns, mini.nvim
│   ├── lsp.lua         # nvim-lspconfig, conform.nvim, blink.cmp
│   ├── telescope.lua   # telescope and telescope-specific deps/config
│   ├── ui.lua          # which-key, colorscheme
│   └── treesitter.lua  # nvim-treesitter
├── kickstart/
│   └── plugins/        # existing optional/example modules; leave in place
├── custom/
│   └── plugins/        # existing user-extension space; leave in place
└── story/
    ├── bootstrap.lua
    └── bootstrap/lazy.lua
```

The strongest grouping signal already exists in the current inline table comments, so planning should use those concern seams instead of inventing new boundaries from load timing or ownership. `gitsigns`, `guess-indent`, and `mini.nvim` fit naturally in `editor.lua`; Telescope stands alone; LSP, formatting, and completion belong together in `lsp.lua`; `which-key` plus colorscheme belong in `ui.lua`; and Treesitter is clearer in its own file because it carries a large config block and build hook. [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md]

### Pattern 1: Explicit Import Wiring in `bootstrap.lua`
**What:** Keep `require('lazy').setup(...)` in `lua/story/bootstrap.lua`, but replace the inline active plugin array with an explicit `spec = { { import = 'plugins' } }` entry. [VERIFIED: lua/story/bootstrap.lua] [CITED: https://lazy.folke.io/usage/structuring]
**When to use:** Immediately in Plan `02-01`, because it turns imports into the canonical source of truth without changing the Phase 1 bootstrap boundaries. [VERIFIED: .planning/ROADMAP.md] [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md]
**Example:**
```lua
-- Source pattern: https://lazy.folke.io/usage/structuring
require('lazy').setup({
  spec = {
    { import = 'plugins' },
  },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
```

### Pattern 2: Each Concern File Returns a Plain List of Specs
**What:** Each file under `lua/plugins/` should return a plain Lua array of plugin specs; do not execute side effects at file load time outside the spec tables. [CITED: https://lazy.folke.io/usage/structuring] [VERIFIED: lua/kickstart/plugins/debug.lua] [VERIFIED: lua/kickstart/plugins/lint.lua]
**When to use:** For every new concern file in Phase 2. [VERIFIED: .planning/ROADMAP.md]
**Example:**
```lua
-- Source basis: current repo spec style + https://lazy.folke.io/usage/structuring
return {
  { 'NMAC427/guess-indent.nvim', opts = {} },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
}
```

### Pattern 3: Preserve Existing Plugin Bodies Mostly Verbatim
**What:** Move the existing plugin specs with minimal edits so `config`, `opts`, `keys`, `dependencies`, `event`, `build`, `branch`, and `enabled` remain attached to the same plugin entries they already configure. [VERIFIED: lua/story/bootstrap.lua]
**When to use:** During the file split in Plans `02-01` and `02-02`. [VERIFIED: .planning/ROADMAP.md]
**Example:**
```lua
-- Source basis: current Telescope spec in lua/story/bootstrap.lua
return {
  {
    'nvim-telescope/telescope.nvim',
    enabled = true,
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function() return vim.fn.executable 'make' == 1 end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- existing Telescope config body copied here
    end,
  },
}
```

### Anti-Patterns to Avoid
- **Hybrid active spec sources:** Do not leave active shipped plugin entries inline in `lua/story/bootstrap.lua` after adding imports; the phase decision explicitly forbids ending with a hybrid layout. [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md]
- **Custom recursive loaders:** Do not build a manual directory walker or `require` fan-out; `lazy.nvim` already merges module specs and top-level submodules automatically. [CITED: https://lazy.folke.io/usage/structuring]
- **Grouping by lazy-load timing:** Do not split files into `startup.lua`, `event.lua`, or `deps.lua`; the phase decision prefers concern-oriented grouping. [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md]
- **Config rewrites disguised as file moves:** Do not change current plugin behavior unless needed to preserve loading under the new layout. [VERIFIED: .planning/PROJECT.md]
- **Moving optional/example namespaces into `lua/plugins/`:** Leave `lua/kickstart/plugins/` and `lua/custom/plugins/` where they are in Phase 2. [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Plugin file discovery | Custom `require` loop over `lua/plugins` | `lazy.nvim` module import support | Top-level submodules are already auto-merged and cached by `lazy.nvim`. [CITED: https://lazy.folke.io/usage/structuring] |
| Spec merging across files | Manual deep-merge helpers | `lazy.nvim` import merge behavior | Upstream already documents which keys merge and which override. [CITED: https://lazy.folke.io/usage/structuring] |
| Optional-module compatibility layer | Broad relocation of `kickstart` or `custom` plugin modules | Leave existing namespaces in place unless a tiny shim becomes necessary | Phase 2 scope explicitly avoids broad optional-module migration. [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md] |
| New validation harness | Custom shell framework or test runner bootstrap | Reuse repo headless `nvim --headless -u ./init.lua` smoke commands | The repo has no automated test framework today, and the Phase 1 validation path already works. [VERIFIED: local command `nvim --headless -u ./init.lua "+lua assert(vim.g.mapleader == ' ' and vim.g.maplocalleader == ' ' and type(vim.g.have_nerd_font) == 'boolean')" "+Lazy! health" "+checkhealth kickstart" +qa`] [VERIFIED: codebase grep] |

**Key insight:** The hard part of this phase is not file creation; it is preserving the exact current plugin bodies while changing only the source-of-truth layout. `lazy.nvim` already solves the loader and merge problems, so planning should spend effort on clean grouping and parity checks instead of infrastructure code. [VERIFIED: lua/story/bootstrap.lua] [CITED: https://lazy.folke.io/usage/structuring]

## Runtime State Inventory

| Category | Items Found | Action Required |
|----------|-------------|-----------------|
| Stored data | None identified in repo-scoped research; this phase moves Lua source files and does not target a renamed persisted key, collection, or schema. [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md] [VERIFIED: codebase grep] | Code edit only; no data migration task should be planned. [VERIFIED: .planning/ROADMAP.md] |
| Live service config | None identified in repo-scoped research; the repo does not declare an external service that stores plugin layout configuration outside git for this phase. [VERIFIED: codebase grep] | No action from this phase. [VERIFIED: .planning/ROADMAP.md] |
| OS-registered state | None identified in repo-scoped research; the phase does not rename executables, services, or launch registrations. [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md] | No action from this phase. [VERIFIED: .planning/ROADMAP.md] |
| Secrets/env vars | None identified for this phase; plugin import layout does not introduce or rename environment-variable lookups in the current bootstrap path. [VERIFIED: codebase grep] | No action from this phase. [VERIFIED: .planning/ROADMAP.md] |
| Build artifacts | No stale artifact migration is expected from this phase; plugin files are loaded dynamically from the repo at startup. [VERIFIED: codebase grep] | Code edit only; no install-time artifact migration task required. [VERIFIED: .planning/ROADMAP.md] |

## Common Pitfalls

### Pitfall 1: Hybrid Source of Truth
**What goes wrong:** The planner adds `spec = { { import = 'plugins' } }` but leaves active shipped plugin specs inline in `lua/story/bootstrap.lua`, creating duplicate or confusing plugin definitions. [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md] [CITED: https://lazy.folke.io/usage/structuring]
**Why it happens:** Inline specs are easy to keep around “temporarily,” especially during a staged move. [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md]
**How to avoid:** Make import wiring first, move all active shipped specs into `lua/plugins/*.lua`, then delete the old inline active entries in the same phase. [VERIFIED: .planning/ROADMAP.md] [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md]
**Warning signs:** `lua/story/bootstrap.lua` still contains plugin repo strings like `guess-indent.nvim`, `telescope.nvim`, `nvim-lspconfig`, or `nvim-treesitter` after `lua/plugins/` exists. [VERIFIED: lua/story/bootstrap.lua]

### Pitfall 2: Grouping by Mechanics Instead of Concern
**What goes wrong:** Files end up named around load timing or internals, which makes the layout harder to navigate than the current comments. [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md]
**Why it happens:** The current inline block contains many `event`, `keys`, `dependencies`, and `build` details that tempt a mechanical split. [VERIFIED: lua/story/bootstrap.lua]
**How to avoid:** Use the repo's current semantic sections as the boundary: editor tools, Telescope, language tooling, UI, and Treesitter. [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md]
**Warning signs:** New file names look like `startup.lua`, `deps.lua`, or `events.lua` instead of user-facing concerns. [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md]

### Pitfall 3: Breaking Local Config Closures While Moving Specs
**What goes wrong:** A plugin still exists in the new file, but keymaps, autocmds, or option-dependent logic stop working because part of the config block was dropped or rewritten. [VERIFIED: lua/story/bootstrap.lua]
**Why it happens:** Several current specs contain large `config = function()` bodies with nested locals, autocmds, and buffer-local keymaps, especially Telescope, LSP, mini.nvim, and Treesitter. [VERIFIED: lua/story/bootstrap.lua]
**How to avoid:** Move each plugin body mostly verbatim first; only change indentation, surrounding array wrappers, or nearby comments as needed. [VERIFIED: lua/story/bootstrap.lua]
**Warning signs:** Headless `Lazy! health` still passes, but interactive features tied to Telescope or LSP mappings disappear after the move. [VERIFIED: lua/story/bootstrap.lua] [ASSUMED]

### Pitfall 4: Premature Optional-Module Migration
**What goes wrong:** The phase starts relocating `lua/kickstart/plugins/*` or enabling `custom.plugins` imports as part of the active layout migration. [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md]
**Why it happens:** Those directories already look close to the target pattern, so it is tempting to “finish the job” early. [VERIFIED: lua/kickstart/plugins/debug.lua] [VERIFIED: lua/custom/plugins/init.lua]
**How to avoid:** Keep those namespaces in place and treat them as separate compatibility surfaces unless a tiny shim is explicitly needed. [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md]
**Warning signs:** The diff starts deleting or mass-moving files under `lua/kickstart/plugins/` or `lua/custom/plugins/`. [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md]

## Code Examples

Verified patterns from official sources and the current repo:

### Import-Driven Bootstrap Wiring
```lua
-- Source: https://lazy.folke.io/usage/structuring
require('lazy').setup({
  spec = {
    { import = 'plugins' },
  },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
```

### Concern File for Language Tooling
```lua
-- Source basis: current repo specs in lua/story/bootstrap.lua
return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      -- existing LSP config body copied here
    end,
  },
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {},
  },
}
```

### Headless Structural Gate
```bash
sh -c "rg -n \"import = 'plugins'\" lua/story/bootstrap.lua \
  && ! rg -n \"guess-indent.nvim|telescope.nvim|nvim-lspconfig|conform.nvim|blink.cmp|tokyonight.nvim|mini.nvim|nvim-treesitter\" lua/story/bootstrap.lua \
  && nvim --headless -u ./init.lua \"+Lazy! health\" \"+checkhealth kickstart\" +qa"
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Large inline plugin arrays maintained manually in `init.lua` or another bootstrap file | `lazy.nvim` docs recommend modular plugin specs through a module like `plugins` and top-level auto-merged submodules | Current official docs as crawled in April 2026 | Phase 2 can follow a documented path instead of inventing custom import infrastructure. [CITED: https://lazy.folke.io/usage/structuring] |
| Manual dependency ordering through packer-era `after`/`wants` patterns | `lazy.nvim` uses `dependencies` and automatic module loading instead of most manual sequencing | Documented in current migration guide | Planning should preserve current `dependencies` fields and avoid introducing packer-style ordering hacks during the file split. [CITED: https://lazy.folke.io/usage/migration] |

**Deprecated/outdated:**
- Treating the inline plugin table in `lua/story/bootstrap.lua` as the long-term editing surface is outdated for this repo once Phase 2 lands, because the roadmap and context lock in `lua/plugins` imports as the canonical active layout. [VERIFIED: .planning/ROADMAP.md] [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md]

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | Interactive regressions after the move are most likely to surface in Telescope or LSP keymap/config closures even if headless health passes. [ASSUMED] | Common Pitfalls | Medium; the planner might under-sample another moved plugin area during manual parity checks. |

## Open Questions

1. **Should Phase 2 wire `custom.plugins` into the active `spec` list now, or leave it as a dormant example path?**
   - What we know: `lua/custom/plugins/init.lua` exists today, but the current inline table only contains a commented import example, and the context says `lua/custom/plugins/` should remain a user-extension space rather than the main home for shipped active specs. [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: lua/custom/plugins/init.lua] [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md]
   - What's unclear: Whether the planner wants that namespace activated during Phase 2 for convenience or left untouched to minimize scope. [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md]
   - Recommendation: Leave it untouched in Phase 2 unless a tiny compatibility shim is required, because PLUG-03 and broader optional-module reconciliation are explicitly deferred to Phase 4. [VERIFIED: .planning/REQUIREMENTS.md] [VERIFIED: .planning/ROADMAP.md]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| Neovim | Runtime validation and headless smoke checks | ✓ | `NVIM v0.12.1` | — [VERIFIED: local command `nvim --version`] |
| Git | `lazy.nvim` bootstrap clone path and repo operations | ✓ | `2.53.0` | — [VERIFIED: local command `git --version`] |
| `make` | Existing `telescope-fzf-native.nvim` build hook when installed | ✓ | `GNU Make 3.81` | Plugin is already guarded with `cond = function() return vim.fn.executable 'make' == 1 end`. [VERIFIED: local command `make --version | head -1`] [VERIFIED: lua/story/bootstrap.lua] |
| `unzip` | Existing `kickstart` health expectations | ✓ | `UnZip 6.00` | — [VERIFIED: local command `unzip -v | head -1`] [VERIFIED: lua/kickstart/health.lua] |
| `rg` | Existing `kickstart` health expectations and planner verification commands | ✓ | `ripgrep 15.1.0` | — [VERIFIED: local command `rg --version | head -1`] [VERIFIED: lua/kickstart/health.lua] |
| `stylua` | Optional formatting convenience for edited Lua files | ✗ | — | Use the repo's existing formatting style manually or format through Neovim tooling if desired. [VERIFIED: local command `stylua --version`] [VERIFIED: `.stylua.toml` exists] |

**Missing dependencies with no fallback:**
- None for this phase. [VERIFIED: local environment audit]

**Missing dependencies with fallback:**
- `stylua` is not installed locally, but Phase 2 can still execute with manual style preservation because no required formatter gate is defined in the repo today. [VERIFIED: local environment audit] [VERIFIED: codebase grep]

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | None dedicated; use repo headless Neovim smoke commands as the validation harness. [VERIFIED: codebase grep] |
| Config file | `none — see Wave 0`; there is no `tests/`, `spec/`, `package.json`, or dedicated test config in the repo root. [VERIFIED: codebase grep] |
| Quick run command | `sh -c "rg -n \"import = 'plugins'\" lua/story/bootstrap.lua && test -d lua/plugins && nvim --headless -u ./init.lua \"+Lazy! health\" +qa"` [VERIFIED: local command `nvim --headless -u ./init.lua "+lua assert(vim.g.mapleader == ' ' and vim.g.maplocalleader == ' ' and type(vim.g.have_nerd_font) == 'boolean')" "+Lazy! health" "+checkhealth kickstart" +qa`] |
| Full suite command | `sh -c "rg -n \"import = 'plugins'\" lua/story/bootstrap.lua && ! rg -n \"guess-indent.nvim|telescope.nvim|nvim-lspconfig|conform.nvim|blink.cmp|tokyonight.nvim|mini.nvim|nvim-treesitter\" lua/story/bootstrap.lua && nvim --headless -u ./init.lua \"+Lazy! health\" \"+checkhealth kickstart\" +qa"` [VERIFIED: local command `nvim --headless -u ./init.lua "+lua assert(vim.g.mapleader == ' ' and vim.g.maplocalleader == ' ' and type(vim.g.have_nerd_font) == 'boolean')" "+Lazy! health" "+checkhealth kickstart" +qa`] |

### Phase Requirements → Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| PLUG-01 | Active shipped plugins load from `lua/plugins` imports rather than the old inline list | smoke + structural | `sh -c "rg -n \"import = 'plugins'\" lua/story/bootstrap.lua && ! rg -n \"guess-indent.nvim|telescope.nvim|nvim-lspconfig|conform.nvim|blink.cmp|tokyonight.nvim|mini.nvim|nvim-treesitter\" lua/story/bootstrap.lua && nvim --headless -u ./init.lua \"+Lazy! health\" +qa"` | ✅ command verified [VERIFIED: local smoke command] |
| PLUG-02 | Plugin specs are grouped into coherent concern files under `lua/plugins/` | structural | `sh -c "test -d lua/plugins && test $(find lua/plugins -maxdepth 1 -name '*.lua' | wc -l) -ge 5 && rg -n \"return \\{\" lua/plugins/*.lua"` | ✅ command pattern verified [VERIFIED: local shell tools] |

### Sampling Rate
- **Per task commit:** `sh -c "rg -n \"import = 'plugins'\" lua/story/bootstrap.lua && test -d lua/plugins && nvim --headless -u ./init.lua \"+Lazy! health\" +qa"` [VERIFIED: local smoke command]
- **Per wave merge:** `sh -c "rg -n \"import = 'plugins'\" lua/story/bootstrap.lua && ! rg -n \"guess-indent.nvim|telescope.nvim|nvim-lspconfig|conform.nvim|blink.cmp|tokyonight.nvim|mini.nvim|nvim-treesitter\" lua/story/bootstrap.lua && nvim --headless -u ./init.lua \"+Lazy! health\" \"+checkhealth kickstart\" +qa"` [VERIFIED: local smoke command]
- **Phase gate:** Full suite green before `/gsd-verify-work`. [VERIFIED: .planning/config.json]

### Wave 0 Gaps
- None required before implementation; existing shell and headless smoke commands are sufficient for this structural phase. [VERIFIED: codebase grep] [VERIFIED: local environment audit]

## Security Domain

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|-----------------|
| V2 Authentication | no | Not in scope for a local plugin-layout refactor. [VERIFIED: .planning/ROADMAP.md] |
| V3 Session Management | no | Not in scope for a local plugin-layout refactor. [VERIFIED: .planning/ROADMAP.md] |
| V4 Access Control | no | Not in scope for a local plugin-layout refactor. [VERIFIED: .planning/ROADMAP.md] |
| V5 Input Validation | no | This phase restructures static plugin specs rather than user-input handling. [VERIFIED: .planning/ROADMAP.md] |
| V6 Cryptography | no | This phase adds no cryptographic behavior. [VERIFIED: .planning/ROADMAP.md] |

### Known Threat Patterns for Neovim + `lazy.nvim`

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Remote plugin-manager bootstrap on first install | Tampering / Elevation | Keep the existing `lazy.nvim` bootstrap helper untouched: same official GitHub URL, stable branch, shell-error check, and runtimepath prepend. [VERIFIED: lua/story/bootstrap/lazy.lua] |
| Build hooks execute external commands (`make`, `:TSUpdate`) | Elevation | Do not add or rewrite build hooks during the structural split; preserve existing `build` clauses exactly where they already exist. [VERIFIED: lua/story/bootstrap.lua] |
| Duplicate spec definitions from hybrid inline/import state | Tampering | Use a single canonical import source and remove old active inline entries before phase completion. [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md] [CITED: https://lazy.folke.io/usage/structuring] |

## Sources

### Primary (HIGH confidence)
- [`.planning/phases/02-plugin-import-layout/02-CONTEXT.md`](./02-CONTEXT.md) - locked phase decisions, discretion, canonical refs, and scope.
- [`.planning/REQUIREMENTS.md`](/Users/danieldavies/dev/nvim/storynvim/.planning/REQUIREMENTS.md) - `PLUG-01` and `PLUG-02` requirements plus Phase 4 deferral for `PLUG-03`.
- [`.planning/ROADMAP.md`](/Users/danieldavies/dev/nvim/storynvim/.planning/ROADMAP.md) - Phase 2 goal, success criteria, and plan decomposition.
- [`lua/story/bootstrap.lua`](/Users/danieldavies/dev/nvim/storynvim/lua/story/bootstrap.lua) - current inline active plugin table, current plugin section boundaries, and validation targets.
- [`lua/story/bootstrap/lazy.lua`](/Users/danieldavies/dev/nvim/storynvim/lua/story/bootstrap/lazy.lua) - current `lazy.nvim` bootstrap helper that Phase 2 must not disturb.
- [`lua/kickstart/plugins/debug.lua`](/Users/danieldavies/dev/nvim/storynvim/lua/kickstart/plugins/debug.lua) - repo example of a modular `LazySpec` plugin file.
- [`lua/kickstart/plugins/lint.lua`](/Users/danieldavies/dev/nvim/storynvim/lua/kickstart/plugins/lint.lua) - repo example of a focused plugin module with local autocommands.
- [`lua/custom/plugins/init.lua`](/Users/danieldavies/dev/nvim/storynvim/lua/custom/plugins/init.lua) - existing user-extension namespace pattern.
- https://lazy.folke.io/usage/structuring - official `lazy.nvim` docs for modular plugin specs, `setup("plugins")`, and `import` merge behavior.
- https://lazy.folke.io/usage/migration - official `lazy.nvim` migration guide for current dependency and module-loading semantics.
- https://api.github.com/repos/folke/lazy.nvim/releases/latest - current latest verified `lazy.nvim` release metadata.

### Secondary (MEDIUM confidence)
- None. [VERIFIED: research session]

### Tertiary (LOW confidence)
- None beyond the single explicit assumption logged above. [VERIFIED: research session]

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - Current repo usage, local environment checks, and official `lazy.nvim` docs all agree on the recommended stack. [VERIFIED: local environment audit] [VERIFIED: lua/story/bootstrap.lua] [CITED: https://lazy.folke.io/usage/structuring]
- Architecture: HIGH - The exact target pattern is both locked by phase context and documented by upstream `lazy.nvim`. [VERIFIED: .planning/phases/02-plugin-import-layout/02-CONTEXT.md] [CITED: https://lazy.folke.io/usage/structuring]
- Pitfalls: MEDIUM - Most are directly visible in the current code and phase scope, but one interactive-regression warning remains assumption-backed until implementation. [VERIFIED: lua/story/bootstrap.lua] [ASSUMED]

**Research date:** 2026-04-11
**Valid until:** 2026-05-11 for repo structure findings; re-check `lazy.nvim` docs and release metadata after that. [VERIFIED: research session]
