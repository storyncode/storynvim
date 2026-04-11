---
phase: 03
slug: core-module-extraction
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-04-11
---

# Phase 03 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | other — headless Neovim smoke checks plus manual spot checks |
| **Config file** | none — existing runtime commands only |
| **Quick run command** | `nvim --headless -u ./init.lua "+lua local map=vim.fn.maparg('<C-h>', 'n', false, true); assert(vim.o.number == true and vim.o.signcolumn == 'yes'); assert(type(map) == 'table' and map.rhs == '<C-w><C-h>'); local ac=vim.api.nvim_get_autocmds({group='kickstart-highlight-yank'}); assert(#ac > 0)" +qa` |
| **Full suite command** | `nvim --headless -u ./init.lua "+checkhealth kickstart" +qa` |
| **Estimated runtime** | ~10 seconds |

---

## Sampling Rate

- **After every task commit:** Run `nvim --headless -u ./init.lua "+lua local map=vim.fn.maparg('<C-h>', 'n', false, true); assert(vim.o.number == true and vim.o.signcolumn == 'yes'); assert(type(map) == 'table' and map.rhs == '<C-w><C-h>'); local ac=vim.api.nvim_get_autocmds({group='kickstart-highlight-yank'}); assert(#ac > 0)" +qa`
- **After every plan wave:** Run `nvim --headless -u ./init.lua "+checkhealth kickstart" +qa`
- **Before `/gsd-verify-work`:** Full suite must be green
- **Max feedback latency:** 10 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Threat Ref | Secure Behavior | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|------------|-----------------|-----------|-------------------|-------------|--------|
| 03-01-01 | 01 | 1 | CORE-01 | T-03-01 | Options remain explicitly defined in repo-owned modules without changing startup values | smoke | `nvim --headless -u ./init.lua "+lua assert(vim.o.number == true and vim.o.signcolumn == 'yes' and vim.o.scrolloff == 10)" +qa` | ✅ | ⬜ pending |
| 03-02-01 | 02 | 2 | CORE-02 | T-03-01 | Global non-plugin mappings remain registered with the same RHS values | smoke | `nvim --headless -u ./init.lua "+lua local esc=vim.fn.maparg('<Esc>', 'n', false, true); local left=vim.fn.maparg('<C-h>', 'n', false, true); assert(esc.rhs == '<Cmd>nohlsearch<CR>' or esc.rhs == '<cmd>nohlsearch<CR>'); assert(left.rhs == '<C-w><C-h>')" +qa` | ✅ | ⬜ pending |
| 03-03-01 | 03 | 3 | CORE-03 | T-03-01 | Always-on autocmds still register and startup helpers still complete under headless startup | smoke | `nvim --headless -u ./init.lua "+lua local ac=vim.api.nvim_get_autocmds({group='kickstart-highlight-yank'}); assert(#ac > 0)" "+checkhealth kickstart" +qa` | ✅ | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

Existing infrastructure covers all phase requirements.

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Startup file readability after extraction | CORE-01, CORE-02, CORE-03 | Structural clarity is subjective and complements the smoke checks | Read `init.lua`, `lua/story/bootstrap.lua`, and the new `lua/core/*.lua` files to confirm ownership is obvious and the startup flow still reads top-to-bottom. |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 10s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
