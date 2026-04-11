---
phase: 01
slug: bootstrap-skeleton
status: verified
threats_open: 0
asvs_level: 1
created: 2026-04-11
updated: 2026-04-11
---

# Phase 01 — Security

> Per-phase security contract: threat register, accepted risks, and audit trail.

---

## Trust Boundaries

| Boundary | Description | Data Crossing |
|----------|-------------|---------------|
| local config -> remote git clone | First bootstrap may execute `git clone` against GitHub when `lazy.nvim` is missing | Remote code fetch metadata and plugin manager source |
| early globals -> bootstrap module | Order-sensitive globals cross from `init.lua` into module-owned startup code | In-process startup state and execution ordering |
| bootstrap module -> shared helper / lazy.nvim | Startup control passes into helper code before plugin setup | Runtimepath state and plugin manager initialization |
| startup path -> health checks | Headless startup validation exercises lazy-loaded side effects | Runtime assertions and health-check output |

---

## Threat Register

| Threat ID | Category | Component | Disposition | Mitigation | Status |
|-----------|----------|-----------|-------------|------------|--------|
| T-01-01 | T | `lua/story/bootstrap.lua` lazy clone block | mitigate | Clone URL, `--filter=blob:none`, `--branch=stable`, shell-error handling, and `rtp:prepend` behavior preserved in `lua/story/bootstrap/lazy.lua` | closed |
| T-01-02 | E | `lua/story/bootstrap.lua` module load path | mitigate | `lua/story/bootstrap.lua` exposes `M.setup()` and keeps side effects inside setup rather than at require time | closed |
| T-01-03 | D | `lua/story/bootstrap.lua` startup ordering | mitigate | Helper call remains before `require('lazy').setup(...)`, preserving bootstrap ordering | closed |
| T-01-04 | D | `init.lua` entrypoint rewrite | mitigate | `init.lua` reduced to three early globals plus `require('story.bootstrap').setup()` | closed |
| T-01-05 | T | startup order across `init.lua` and `lua/story/bootstrap.lua` | mitigate | Headless smoke assertion plus `Lazy! health` and `checkhealth kickstart` passed on the real entrypoint path | closed |
| T-01-06 | E | lazy-loaded plugin side effects | mitigate | Full headless startup validation used instead of grep-only checks | closed |
| T-01-07 | T | `lua/story/bootstrap/lazy.lua` remote bootstrap | mitigate | Extracted helper kept the same remote URL, clone flags, shell-error path, and runtimepath prepend sequence | closed |
| T-01-08 | D | helper call ordering in `lua/story/bootstrap.lua` | mitigate | Verified helper invocation appears before `require('lazy').setup(...)` in file order | closed |
| T-01-09 | E | hidden side effects after module split | mitigate | Helper is required explicitly from the ordered bootstrap module and validated through real startup | closed |

*Status: open · closed*
*Disposition: mitigate (implementation required) · accept (documented risk) · transfer (third-party)*

---

## Accepted Risks Log

No accepted risks.

---

## Security Audit Trail

| Audit Date | Threats Total | Closed | Open | Run By |
|------------|---------------|--------|------|--------|
| 2026-04-11 | 9 | 9 | 0 | Codex / gsd-secure-phase |

---

## Sign-Off

- [x] All threats have a disposition (mitigate / accept / transfer)
- [x] Accepted risks documented in Accepted Risks Log
- [x] `threats_open: 0` confirmed
- [x] `status: verified` set in frontmatter

**Approval:** verified 2026-04-11
