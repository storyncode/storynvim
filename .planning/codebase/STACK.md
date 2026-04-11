# Technology Stack

**Analysis Date:** 2026-04-11

## Languages

**Primary:**
- Lua - Main configuration language for the editor setup in `init.lua`, `lua/kickstart/health.lua`, and plugin specs under `lua/kickstart/plugins/`.

**Secondary:**
- Vim helpdoc - User-facing documentation in `doc/kickstart.txt`.
- YAML - CI workflow definition in `.github/workflows/stylua.yml`.
- Markdown - Project documentation in `README.md` and `LICENSE.md`.

## Runtime

**Environment:**
- Neovim 0.11+ - Required editor/runtime target; enforced by the health check in `lua/kickstart/health.lua` and documented in `README.md`.
- LuaJIT - Configured as the Lua language-server runtime in the `lua_ls` setup in `init.lua`.

**Package Manager:**
- `lazy.nvim` - Plugin manager bootstrapped directly from GitHub in `init.lua`.
- Lockfile: supported but missing from the repository root; `lazy-lock.json` is ignored in `.gitignore` and referenced in `README.md`.

## Frameworks

**Core:**
- Neovim Lua API - Primary application framework used throughout `init.lua` and `lua/kickstart/health.lua`.
- `lazy.nvim` - Plugin loading, dependency resolution, and lazy-loading orchestration in `init.lua`.

**Testing:**
- Not detected - No automated test framework config or test files are present in the repository root or `lua/`.

**Build/Dev:**
- `stylua` - Lua formatter configured in `.stylua.toml`, referenced by the LSP/tooling setup in `init.lua`, and enforced in CI by `.github/workflows/stylua.yml`.
- GitHub Actions - Hosted CI runner executing format checks in `.github/workflows/stylua.yml`.
- `mason.nvim` ecosystem - Installs LSP servers and related developer tools from inside Neovim in `init.lua` and `lua/kickstart/plugins/debug.lua`.

## Key Dependencies

**Critical:**
- `folke/lazy.nvim` - Required plugin manager; auto-cloned into `stdpath('data')` by `git clone` in `init.lua`.
- `neovim/nvim-lspconfig` - Core LSP client configuration in `init.lua`.
- `mason-org/mason.nvim` - Tool installer backing LSP/DAP setup in `init.lua` and `lua/kickstart/plugins/debug.lua`.
- `mason-org/mason-lspconfig.nvim` - Bridges Mason packages with LSP config in `init.lua`.
- `WhoIsSethDaniel/mason-tool-installer.nvim` - Ensures configured tools are installed in `init.lua`.
- `stevearc/conform.nvim` - Format-on-save orchestration in `init.lua`.
- `saghen/blink.cmp` - Completion engine in `init.lua`.
- `nvim-treesitter/nvim-treesitter` - Syntax parsing and highlighting in `init.lua`.
- `nvim-telescope/telescope.nvim` - Search and picker UI in `init.lua`.

**Infrastructure:**
- `lewis6991/gitsigns.nvim` - Git gutter and hunk operations in `init.lua` and `lua/kickstart/plugins/gitsigns.lua`.
- `folke/which-key.nvim` - Keybinding discovery in `init.lua`.
- `nvim-lua/plenary.nvim` - Shared Lua utility dependency for Telescope, todo-comments, and Neo-tree in `init.lua` and `lua/kickstart/plugins/neo-tree.lua`.
- `j-hui/fidget.nvim` - LSP status notifications in `init.lua`.
- `L3MON4D3/LuaSnip` - Snippet engine for completion in `init.lua`.
- `folke/tokyonight.nvim` - Colorscheme in `init.lua`.
- `nvim-mini/mini.nvim` - Statusline and textobject helpers in `init.lua`.
- `mfussenegger/nvim-lint` - Optional lint integration in `lua/kickstart/plugins/lint.lua`.
- `mfussenegger/nvim-dap`, `rcarriga/nvim-dap-ui`, `jay-babu/mason-nvim-dap.nvim`, `leoluz/nvim-dap-go` - Optional debug stack in `lua/kickstart/plugins/debug.lua`.
- `windwp/nvim-autopairs`, `lukas-reineke/indent-blankline.nvim`, `nvim-neo-tree/neo-tree.nvim` - Optional editor UX modules in `lua/kickstart/plugins/`.

## Configuration

**Environment:**
- No `.env` files were detected at the repository root.
- Runtime configuration is code-driven in `init.lua`; there is no separate package manifest or app config file.
- User-specific plugin extension points live under `lua/custom/plugins/`, with the starter stub in `lua/custom/plugins/init.lua`.
- Feature toggles are set via globals and Neovim options, for example `vim.g.have_nerd_font` and clipboard/keymap/editor settings in `init.lua`.

**Build:**
- `.stylua.toml` defines formatting rules for Lua files.
- `.github/workflows/stylua.yml` defines the only detected CI/build automation.
- `.gitignore` controls generated/local artifacts including `lazy-lock.json`, `.luarc.json`, and local `nvim` data.

## Platform Requirements

**Development:**
- `git`, `make`, `unzip`, and `rg` are checked by `:checkhealth` in `lua/kickstart/health.lua`.
- `README.md` additionally documents `gcc`, `fd`/`fd-find`, `tree-sitter` CLI, a clipboard tool, and an optional Nerd Font.
- Some optional modules expect extra host tools:
- `stylua` for Lua formatting via `conform.nvim` in `init.lua`.
- `markdownlint` for Markdown linting in `lua/kickstart/plugins/lint.lua`.
- `delve` for Go debugging in `lua/kickstart/plugins/debug.lua`.
- `make` is required for native/plugin build steps such as `telescope-fzf-native.nvim` and optional `LuaSnip` JS regexp support in `init.lua`.

**Production:**
- Not a deployable service. This repository is a local Neovim configuration intended to be cloned into the Neovim config directory described in `README.md`.
- Runtime state and installed plugins live in Neovim-managed local directories such as `stdpath('data')`, as used in `init.lua`.

---

*Stack analysis: 2026-04-11*
