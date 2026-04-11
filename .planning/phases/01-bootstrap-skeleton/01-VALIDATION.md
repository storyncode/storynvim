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
| 01-01-01 | 01 | 1 | BOOT-01 | T-01-01 | Bootstrap extraction keeps `init.lua` limited to early globals plus the bootstrap entrypoint | smoke + grep | `rg -n "mapleader|maplocalleader|have_nerd_font|require\\(" init.lua` | ❌ W0 | ⬜ pending |
| 01-02-01 | 02 | 1 | BOOT-02 | T-01-02 | `lazy.nvim` clone/bootstrap path still loads and health checks succeed | smoke | `nvim --headless -u ./init.lua "+Lazy! health" +qa` | ✅ | ⬜ pending |
| 01-03-01 | 03 | 2 | BOOT-03 | T-01-03 | Early globals remain available before mappings and plugin setup | smoke | `nvim --headless -u ./init.lua "+lua assert(vim.g.mapleader == ' ' and vim.g.maplocalleader == ' ' and type(vim.g.have_nerd_font) == 'boolean')" +qa` | ✅ | ⬜ pending |

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
