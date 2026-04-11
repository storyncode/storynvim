---
phase: 01
slug: bootstrap-skeleton
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-04-11
---

# Phase 01 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | Headless Neovim smoke validation |
| **Config file** | `init.lua` |
| **Quick run command** | `nvim --headless -u ./init.lua "+lua assert(vim.g.mapleader == ' ' and vim.g.maplocalleader == ' ' and type(vim.g.have_nerd_font) == 'boolean')" +qa` |
| **Full suite command** | `nvim --headless -u ./init.lua "+checkhealth kickstart" "+Lazy! health" +qa` |
| **Estimated runtime** | ~15 seconds |

---

## Sampling Rate

- **After every task commit:** Run `nvim --headless -u ./init.lua "+lua assert(vim.g.mapleader == ' ' and vim.g.maplocalleader == ' ' and type(vim.g.have_nerd_font) == 'boolean')" +qa`
- **After every plan wave:** Run `nvim --headless -u ./init.lua "+checkhealth kickstart" "+Lazy! health" +qa`
- **Before `/gsd-verify-work`:** Full suite must be green
- **Max feedback latency:** 30 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Threat Ref | Secure Behavior | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|------------|-----------------|-----------|-------------------|-------------|--------|
| 01-01-01 | 01 | 1 | BOOT-01 | T-01-01 | A dedicated bootstrap module is introduced without changing startup behavior | smoke + grep | `rg -n "function M.setup|require\\('lazy'\\)\\.setup|TextYankPost" lua/story/bootstrap.lua` | ❌ W0 | ⬜ pending |
| 01-01-02 | 01 | 1 | BOOT-03 | T-01-03 | Early globals remain the boundary before the bootstrap module is invoked | smoke | `nvim --headless -u ./init.lua "+lua assert(vim.g.mapleader == ' ' and vim.g.maplocalleader == ' ' and type(vim.g.have_nerd_font) == 'boolean')" +qa` | ✅ | ⬜ pending |
| 01-02-01 | 02 | 2 | BOOT-01 | T-01-01 | `init.lua` is reduced to early globals plus one bootstrap entrypoint | smoke + grep | `sh -c "rg -n \"mapleader|maplocalleader|have_nerd_font|require\\('story\\.bootstrap'\\)\\.setup\\(\\)\" init.lua && ! rg -n \"require\\('lazy'\\)\\.setup|stdpath 'data'.*/lazy/lazy\\.nvim|TextYankPost\" init.lua"` | ❌ W0 | ⬜ pending |
| 01-02-02 | 02 | 2 | BOOT-02, BOOT-03 | T-01-02 / T-01-03 | The real `init.lua` path still reaches `lazy.nvim` and preserves early-global ordering | smoke | `nvim --headless -u ./init.lua "+lua assert(vim.g.mapleader == ' ' and vim.g.maplocalleader == ' ' and type(vim.g.have_nerd_font) == 'boolean')" "+Lazy! health" "+checkhealth kickstart" +qa` | ✅ | ⬜ pending |
| 01-03-01 | 03 | 3 | BOOT-02 | T-01-02 | The extracted helper preserves clone, shell-error, and runtimepath behavior before `lazy.setup` | smoke + grep | `rg -n "git', 'clone'|shell_error|rtp:prepend\\(lazypath\\)" lua/story/bootstrap/lazy.lua` | ❌ W0 | ⬜ pending |
| 01-03-02 | 03 | 3 | BOOT-02, BOOT-03 | T-01-02 / T-01-03 | Final bootstrap path remains thin at the entrypoint and correct in startup order | smoke | `nvim --headless -u ./init.lua "+lua assert(vim.g.mapleader == ' ' and vim.g.maplocalleader == ' ' and type(vim.g.have_nerd_font) == 'boolean')" "+Lazy! health" "+checkhealth kickstart" +qa` | ✅ | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] `scripts` or inline task commands define a reusable headless smoke command for Phase 1 checks, or the plans explicitly keep the commands inline
- [ ] Manual verification step checks that `init.lua` only contains early globals and a bootstrap entrypoint

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| `init.lua` is reduced to minimal orchestration only | BOOT-01 | File shape and readability are structural, not fully captured by a runtime command | Open `init.lua` and verify it only sets early globals, bootstraps `lazy.nvim` prerequisites, and delegates to the bootstrap module without embedding the full prior config body |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 30s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
