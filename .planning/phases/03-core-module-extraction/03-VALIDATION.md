---
phase: 03
slug: core-module-extraction
status: complete
nyquist_compliant: true
wave_0_complete: true
created: 2026-04-11
---

# Phase 03 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | other — checked-in headless Neovim smoke assertions plus manual spot checks |
| **Config file** | `tests/phase_03_core_modules.lua` |
| **Quick run command** | `nvim --headless -u ./init.lua "+lua dofile('tests/phase_03_core_modules.lua'); StoryNvimPhase03.run_all()" +qa` |
| **Full suite command** | `nvim --headless -u ./init.lua "+lua dofile('tests/phase_03_core_modules.lua'); StoryNvimPhase03.run_all()" "+checkhealth kickstart" +qa` |
| **Estimated runtime** | ~10 seconds |

---

## Sampling Rate

- **After every task commit:** Run `nvim --headless -u ./init.lua "+lua dofile('tests/phase_03_core_modules.lua'); StoryNvimPhase03.run_all()" +qa`
- **After every plan wave:** Run `nvim --headless -u ./init.lua "+lua dofile('tests/phase_03_core_modules.lua'); StoryNvimPhase03.run_all()" "+checkhealth kickstart" +qa`
- **Before `/gsd-verify-work`:** Full suite must be green
- **Max feedback latency:** 10 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Threat Ref | Secure Behavior | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|------------|-----------------|-----------|-------------------|-------------|--------|
| 03-01-01 | 01 | 1 | CORE-01 | T-03-01 | Options remain explicitly defined in repo-owned modules without changing startup values | smoke | `nvim --headless -u ./init.lua "+lua dofile('tests/phase_03_core_modules.lua'); StoryNvimPhase03.run_core01()" +qa` | ✅ | ✅ green |
| 03-02-01 | 02 | 2 | CORE-02 | T-03-01 | Global non-plugin mappings remain registered with the same RHS values | smoke | `nvim --headless -u ./init.lua "+lua dofile('tests/phase_03_core_modules.lua'); StoryNvimPhase03.run_core02()" +qa` | ✅ | ✅ green |
| 03-03-01 | 03 | 3 | CORE-03 | T-03-01 | Always-on autocmds still register and startup helpers still complete under headless startup | smoke | `nvim --headless -u ./init.lua "+lua dofile('tests/phase_03_core_modules.lua'); StoryNvimPhase03.run_core03()" "+checkhealth kickstart" +qa` | ✅ | ✅ green |

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

- [x] All tasks have `<automated>` verify or Wave 0 dependencies
- [x] Sampling continuity: no 3 consecutive tasks without automated verify
- [x] Wave 0 covers all MISSING references
- [x] No watch-mode flags
- [x] Feedback latency < 10s
- [x] `nyquist_compliant: true` set in frontmatter

**Approval:** approved

## Validation Audit 2026-04-12

| Metric | Count |
|--------|-------|
| Gaps found | 3 |
| Resolved | 3 |
| Escalated | 0 |

- Replaced ad hoc inline smoke commands with checked-in reusable assertions in `tests/phase_03_core_modules.lua`.
- Corrected the runtimepath assertion to verify the resolved real config root instead of assuming `vim.fn.getcwd()` remains on `runtimepath`.
