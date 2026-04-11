---
phase: 02
slug: plugin-import-layout
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-04-11
---

# Phase 02 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | other — headless Neovim smoke commands plus structural shell checks |
| **Config file** | `none — existing repo uses direct headless commands` |
| **Quick run command** | `sh -c "test -d lua/plugins && nvim --headless -u ./init.lua \"+Lazy! health\" +qa"` |
| **Full suite command** | `sh -c "rg -n \"import = 'plugins'\" lua/story/bootstrap.lua && ! rg -n \"guess-indent.nvim|telescope.nvim|nvim-lspconfig|conform.nvim|blink.cmp|tokyonight.nvim|mini.nvim|nvim-treesitter\" lua/story/bootstrap.lua && nvim --headless -u ./init.lua \"+Lazy! health\" \"+checkhealth kickstart\" +qa"` |
| **Estimated runtime** | ~20 seconds |

---

## Sampling Rate

- **After every task commit:** Run `sh -c "test -d lua/plugins && nvim --headless -u ./init.lua \"+Lazy! health\" +qa"`
- **After every plan wave:** Run `sh -c "rg -n \"import = 'plugins'\" lua/story/bootstrap.lua && ! rg -n \"guess-indent.nvim|telescope.nvim|nvim-lspconfig|conform.nvim|blink.cmp|tokyonight.nvim|mini.nvim|nvim-treesitter\" lua/story/bootstrap.lua && nvim --headless -u ./init.lua \"+Lazy! health\" \"+checkhealth kickstart\" +qa"`
- **Before `/gsd-verify-work`:** Full suite must be green
- **Max feedback latency:** 20 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Threat Ref | Secure Behavior | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|------------|-----------------|-----------|-------------------|-------------|--------|
| 02-01-01 | 02-01 | 1 | PLUG-01 | T-02-01 | New `lua/plugins/editor.lua` and `lua/plugins/telescope.lua` contain moved active shipped specs only; no new remote/plugin bootstrap behavior introduced | structural | `sh -c "test -f lua/plugins/editor.lua && test -f lua/plugins/telescope.lua && rg -n \"NMAC427/guess-indent.nvim|lewis6991/gitsigns.nvim|nvim-telescope/telescope.nvim\" lua/plugins/editor.lua lua/plugins/telescope.lua"` | ❌ W0 | ⬜ pending |
| 02-01-02 | 02-01 | 1 | PLUG-02 | T-02-02 | Concern files stay readable and concern-oriented rather than load-timing-based | structural | `sh -c "rg -n \"return \\{\" lua/plugins/editor.lua lua/plugins/telescope.lua && ! rg -n \"startup|deps|events\" lua/plugins/editor.lua lua/plugins/telescope.lua"` | ❌ W0 | ⬜ pending |
| 02-02-01 | 02-02 | 1 | PLUG-01 | T-02-01 | New `lua/plugins/lsp.lua`, `lua/plugins/coding.lua`, and `lua/plugins/ui.lua` preserve existing plugin `opts`, `config`, `keys`, and `dependencies` bodies | structural | `sh -c "test -f lua/plugins/lsp.lua && test -f lua/plugins/coding.lua && test -f lua/plugins/ui.lua && rg -n \"neovim/nvim-lspconfig|stevearc/conform.nvim|saghen/blink.cmp|folke/tokyonight.nvim|nvim-treesitter/nvim-treesitter\" lua/plugins/lsp.lua lua/plugins/coding.lua lua/plugins/ui.lua"` | ❌ W0 | ⬜ pending |
| 02-02-02 | 02-02 | 1 | PLUG-02 | T-02-02 | Grouping stays concern-based and leaves `lua/kickstart/plugins/` / `lua/custom/plugins/` untouched | structural | `sh -c "test $(find lua/plugins -maxdepth 1 -name '*.lua' | wc -l) -ge 5 && test -f lua/custom/plugins/init.lua && test -f lua/kickstart/plugins/debug.lua"` | ❌ W0 | ⬜ pending |
| 02-03-01 | 02-03 | 2 | PLUG-01 | T-02-03 | `lua/story/bootstrap.lua` uses `import = 'plugins'` as the canonical active spec source and no longer embeds the shipped plugin repo strings inline | smoke + structural | `sh -c "rg -n \"import = 'plugins'\" lua/story/bootstrap.lua && ! rg -n \"guess-indent.nvim|telescope.nvim|nvim-lspconfig|conform.nvim|blink.cmp|tokyonight.nvim|mini.nvim|nvim-treesitter\" lua/story/bootstrap.lua"` | ✅ | ⬜ pending |
| 02-03-02 | 02-03 | 2 | PLUG-02 | T-02-03 | Full startup path still passes lazy health and kickstart health after import switch | smoke | `sh -c "rg -n \"import = 'plugins'\" lua/story/bootstrap.lua && nvim --headless -u ./init.lua \"+Lazy! health\" \"+checkhealth kickstart\" +qa"` | ✅ | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] Existing infrastructure covers all phase requirements.

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Telescope picker mappings, LSP attach mappings, and other interactive config closures still behave normally after the file move | PLUG-01, PLUG-02 | Headless health checks confirm startup, but they do not exercise interactive editor behavior inside moved `config = function()` blocks | Launch `nvim -u ./init.lua`, open a sample project, trigger Telescope with `<leader>sf`, and confirm common LSP/Telescope mappings still register once a language server attaches |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 20s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
