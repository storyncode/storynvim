# External Integrations

**Analysis Date:** 2026-04-11

## APIs & External Services

**Source Control / Code Hosting:**
- GitHub - Primary upstream and plugin source host.
  - SDK/Client: plain `git` CLI invoked from `init.lua` to clone `folke/lazy.nvim`.
  - Auth: inherited from the user’s local Git setup; no repo-local token configuration detected.
- GitHub plugin repositories - Every plugin spec in `init.lua` and `lua/kickstart/plugins/` resolves through `owner/repo` GitHub coordinates handled by `lazy.nvim`.
  - SDK/Client: `lazy.nvim` in `init.lua`.
  - Auth: public clone by default; private repo support is not configured here.

**Developer Tool Registries:**
- Mason package registry - Used to install LSP servers and debug adapters from inside Neovim.
  - SDK/Client: `mason.nvim`, `mason-lspconfig.nvim`, `mason-tool-installer.nvim` in `init.lua`; `mason-nvim-dap.nvim` in `lua/kickstart/plugins/debug.lua`.
  - Auth: none detected.
- Tree-sitter parser distribution - Parsers are installed on demand by `nvim-treesitter`.
  - SDK/Client: `nvim-treesitter` in `init.lua`.
  - Auth: none detected.

**Search / Local Tooling Integration:**
- Ripgrep - External search binary used by Telescope live grep and validated by health checks.
  - SDK/Client: invoked indirectly by `telescope.nvim` in `init.lua`; checked in `lua/kickstart/health.lua`.
  - Auth: not applicable.
- Git - Used both for plugin bootstrap and editor git features.
  - SDK/Client: `vim.fn.system { 'git', 'clone', ... }` in `init.lua`; `gitsigns.nvim` in `init.lua` and `lua/kickstart/plugins/gitsigns.lua`.
  - Auth: inherited from local Git credentials if needed.

## Data Storage

**Databases:**
- None detected.
  - Connection: Not applicable.
  - Client: Not applicable.

**File Storage:**
- Local filesystem only.
- Neovim config files are stored in the repo root and `lua/`.
- Plugin code is installed into Neovim’s data directory using `vim.fn.stdpath('data')` in `init.lua`.
- Persistent undo uses Neovim local files via `vim.o.undofile = true` in `init.lua`.

**Caching:**
- None explicitly configured in-repo.
- Plugin downloads and installed tools are cached implicitly by `lazy.nvim`, `mason.nvim`, and `nvim-treesitter` in their respective Neovim-managed directories referenced from `init.lua`.

## Authentication & Identity

**Auth Provider:**
- None for the application itself.
  - Implementation: This repo is an editor configuration, not a multi-user app or service.

## Monitoring & Observability

**Error Tracking:**
- None detected.

**Logs:**
- Neovim health reporting via `vim.health` in `lua/kickstart/health.lua`.
- Inline runtime errors are raised directly during bootstrap, for example `error('Error cloning lazy.nvim...')` in `init.lua`.
- LSP activity/status feedback is surfaced through `j-hui/fidget.nvim` in `init.lua`.

## CI/CD & Deployment

**Hosting:**
- Not applicable as an application host.
- Source hosting is GitHub-based, implied by clone instructions in `README.md` and CI in `.github/workflows/stylua.yml`.

**CI Pipeline:**
- GitHub Actions - The only detected workflow runs Stylua formatting checks on `pull_request_target` in `.github/workflows/stylua.yml`.

## Environment Configuration

**Required env vars:**
- None required by the repo itself were detected.
- `README.md` documents use of `NVIM_APPNAME` for running this config as an alternate Neovim profile.

**Secrets location:**
- No secret files were detected in the repository root.
- CI uses GitHub-provided `${{ secrets.GITHUB_TOKEN }}` in `.github/workflows/stylua.yml`.

## Webhooks & Callbacks

**Incoming:**
- None detected.

**Outgoing:**
- HTTPS clone/download requests to GitHub for `lazy.nvim` bootstrap in `init.lua`.
- Additional network requests are implied when `lazy.nvim`, `mason.nvim`, or `nvim-treesitter` install plugins/tools/parsers from remote registries referenced by specs in `init.lua` and `lua/kickstart/plugins/debug.lua`.

## External Tooling Interfaces

**Language Servers:**
- `lua_ls` is enabled in `init.lua` through Neovim’s LSP client.
- `stylua` is also listed in the ensured tool set in `init.lua`; it is used as a formatter rather than an LSP server.

**Formatters and Linters:**
- `stylua` formats Lua buffers via `conform.nvim` in `init.lua`.
- `markdownlint` is configured as a Markdown linter in `lua/kickstart/plugins/lint.lua`.

**Debug Adapters:**
- `delve` is the ensured Go debugger in `lua/kickstart/plugins/debug.lua`.

**UI / OS Integration:**
- System clipboard integration is enabled through `vim.o.clipboard = 'unnamedplus'` in `init.lua`.
- Nerd Font and platform clipboard tools are documented OS-level integrations in `README.md`.

---

*Integration audit: 2026-04-11*
