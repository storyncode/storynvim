---
phase: 04
slug: compatibility-and-cleanup
status: draft
nyquist_compliant: false
wave_0_complete: true
created: 2026-04-11
---

# Phase 04 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | headless `nvim` smoke assertions plus manual UAT |
| **Config file** | none — existing Neovim runtime only |
| **Quick run command** | `nvim --headless -u ./init.lua "+checkhealth kickstart" +qa` |
| **Full suite command** | `nvim --headless -u ./init.lua "+doautocmd VimEnter" "+lua vim.wait(500); local cfg=require('lazy.core.config'); for _,name in ipairs({'telescope.nvim','nvim-lspconfig','blink.cmp','conform.nvim','nvim-treesitter','gitsigns.nvim'}) do assert(cfg.plugins[name], name) end; assert(type(require('kickstart.plugins.debug'))=='table'); assert(type(require('kickstart.plugins.lint'))=='table'); assert(type(require('kickstart.plugins.gitsigns'))=='table'); assert(type(require('kickstart.plugins.autopairs'))=='table'); assert(type(require('kickstart.plugins.indent_line'))=='table'); assert(type(require('kickstart.plugins.neo-tree'))=='table'); assert(type(require('custom.plugins'))=='table'); assert(vim.fn.maparg('<leader>sh','n',false,true).lhs == '<Space>sh'); assert(vim.fn.maparg('<leader><leader>','n',false,true).lhs == '<Space><Space>'); local ac=vim.api.nvim_get_autocmds({group='kickstart-highlight-yank'}); assert(#ac > 0); assert(vim.o.clipboard == 'unnamedplus')" "+checkhealth kickstart" +qa` |
| **Estimated runtime** | ~10 seconds |

---

## Sampling Rate

- **After every task commit:** Run `nvim --headless -u ./init.lua "+checkhealth kickstart" +qa`
- **After every plan wave:** Run the full suite command
- **Before `/gsd-verify-work`:** Full suite must be green and manual UAT must be completed
- **Max feedback latency:** 10 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Threat Ref | Secure Behavior | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|------------|-----------------|-----------|-------------------|-------------|--------|
| 04-01-01 | 01 | 1 | PLUG-03 | T-04-01 | Legacy `kickstart.plugins.*` modules and `custom.plugins` resolve without creating a second shipped source | smoke | `nvim --headless -u ./init.lua "+doautocmd VimEnter" "+lua vim.wait(500); assert(type(require('kickstart.plugins.debug'))=='table'); assert(type(require('kickstart.plugins.lint'))=='table'); assert(type(require('kickstart.plugins.gitsigns'))=='table'); assert(type(require('kickstart.plugins.autopairs'))=='table'); assert(type(require('kickstart.plugins.indent_line'))=='table'); assert(type(require('kickstart.plugins.neo-tree'))=='table'); assert(type(require('custom.plugins'))=='table')" +qa` | ✅ | ⬜ pending |
| 04-02-01 | 02 | 2 | PAR-01 / PAR-02 / PAR-03 | T-04-02 | Runtime startup, lazy event loading, health, and core interactive plugin surfaces remain intact | smoke | `nvim --headless -u ./init.lua "+doautocmd VimEnter" "+doautocmd BufWritePre" "+lua vim.wait(500); local cfg=require('lazy.core.config'); for _,name in ipairs({'telescope.nvim','nvim-lspconfig','blink.cmp','conform.nvim','nvim-treesitter','gitsigns.nvim'}) do assert(cfg.plugins[name], name) end; assert(vim.fn.maparg('<leader>sh','n',false,true).lhs == '<Space>sh'); assert(vim.fn.maparg('<leader><leader>','n',false,true).lhs == '<Space><Space>'); local ac=vim.api.nvim_get_autocmds({group='kickstart-highlight-yank'}); assert(#ac > 0); assert(vim.o.clipboard == 'unnamedplus'); assert(pcall(require,'conform')); assert(#vim.api.nvim_get_autocmds({event='LspAttach'}) > 0)" "+checkhealth kickstart" +qa` | ✅ | ⬜ pending |
| 04-03-01 | 03 | 3 | PAR-01 / PAR-03 | T-04-03 | Cleanup removes only code proven dead or duplicate while preserving repo-entrypoint compatibility | smoke | `nvim --headless -u ./init.lua "+doautocmd VimEnter" "+lua vim.wait(500); assert(vim.o.clipboard == 'unnamedplus'); assert(vim.fn.maparg('<leader>sh','n',false,true).lhs == '<Space>sh')" "+checkhealth kickstart" +qa` | ✅ | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- Existing infrastructure covers all phase requirements.

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Telescope picker UX, completion popup behavior, formatting on a real buffer, Treesitter highlighting, and LSP attach mappings in an interactive session | PAR-02 | Headless automation cannot fully prove interactive editor behavior | Open `nvim ./init.lua`, run Telescope search with `<leader>sh`, open a Lua buffer, confirm Treesitter highlighting, trigger completion, format the buffer, and verify LSP attach mappings after language server startup |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 10s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
