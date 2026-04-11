---
phase: 05
slug: documentation-refresh
status: draft
nyquist_compliant: false
wave_0_complete: true
created: 2026-04-11
---

# Phase 05 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | shell + `rg` + headless `nvim` |
| **Config file** | none — existing repo tooling only |
| **Quick run command** | `sh -c "rg -n \"lua/core/|lua/plugins/|lua/custom/plugins/|story.bootstrap\" README.md doc/kickstart.txt init.lua lua/custom/plugins/init.lua && ! rg -n \"single-file|single file\" README.md doc/kickstart.txt init.lua lua/custom/plugins/init.lua"` |
| **Full suite command** | `sh -c "rg -n \"lua/core/|lua/plugins/|lua/custom/plugins/|story.bootstrap\" README.md doc/kickstart.txt init.lua lua/custom/plugins/init.lua && ! rg -n \"single-file|single file\" README.md doc/kickstart.txt init.lua lua/custom/plugins/init.lua && nvim --headless -u NONE -i NONE '+helptags doc' +qall && nvim --headless '+checkhealth kickstart' +qall"` |
| **Estimated runtime** | ~10 seconds |

---

## Sampling Rate

- **After every task commit:** Run the quick run command
- **After every plan wave:** Run the full suite command
- **Before `/gsd-verify-work`:** Full suite must be green
- **Max feedback latency:** 15 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Threat Ref | Secure Behavior | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|------------|-----------------|-----------|-------------------|-------------|--------|
| 05-01-01 | 01 | 1 | DOC-01 | T-05-01 | README and related inline guidance point users to `lua/core/`, `lua/plugins/`, `lua/custom/plugins/`, and `require('story.bootstrap').setup()` rather than monolithic `init.lua` editing | structural | `sh -c "rg -n \"lua/core/|lua/plugins/|lua/custom/plugins/|story.bootstrap\" README.md init.lua lua/custom/plugins/init.lua"` | ✅ | ⬜ pending |
| 05-02-01 | 02 | 1 | DOC-02 | T-05-02 | Help docs and generated tags no longer teach the single-file model as the intended architecture for this fork | structural + smoke | `sh -c "! rg -n \"single-file|single file\" README.md doc/kickstart.txt init.lua lua/custom/plugins/init.lua && nvim --headless -u NONE -i NONE '+helptags doc' +qall"` | ✅ | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

Existing infrastructure covers all phase requirements.

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| README/help text reflects the same customization story without accidental runtime rebrand | DOC-01, DOC-02 | Tone and scope discipline need human review even when grep checks pass | Read the final diffs for `README.md`, `doc/kickstart.txt`, `init.lua`, and `lua/custom/plugins/init.lua`; confirm they describe the modular layout, keep `custom.plugins` as the stable extension path, and do not rename live runtime compatibility surfaces unnecessarily |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 15s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
