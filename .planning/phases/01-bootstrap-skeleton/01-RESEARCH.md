# Phase 01: Bootstrap Skeleton - Research

**Researched:** 2026-04-11
**Domain:** Neovim startup bootstrap refactor with `lazy.nvim`
**Confidence:** HIGH

<user_constraints>
## User Constraints (from CONTEXT.md)

No phase `CONTEXT.md` exists for Phase 1. Research scope is constrained by roadmap, requirements, codebase maps, and the current repo state. [VERIFIED: codebase grep]
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| BOOT-01 | `init.lua` contains only minimal startup orchestration for leader setup, runtime bootstrap, and module entrypoints | Use a thin `init.lua` that sets early globals and delegates to one bootstrap module, matching `lazy.nvim`'s recommended structured setup. [CITED: https://lazy.folke.io/installation] |
| BOOT-02 | `lazy.nvim` bootstrap remains functional after the refactor | Preserve the existing clone-if-missing flow, `vim.opt.rtp:prepend(lazypath)`, and the `require('lazy').setup(...)` call order. [VERIFIED: codebase grep] [CITED: https://lazy.folke.io/installation] |
| BOOT-03 | Module loading order preserves required early globals and runtimepath setup | Keep `mapleader`, `maplocalleader`, and `have_nerd_font` assigned before any keymaps, plugin specs, or `lazy` setup. [VERIFIED: codebase grep] [CITED: https://neovim.io/doc/user/map] [CITED: https://lazy.folke.io/installation] |
</phase_requirements>

## Summary

Phase 1 should be treated as a startup-order-preserving extraction, not a functional redesign. The current repo puts leaders at lines 90-91, `have_nerd_font` at line 94, core keymaps and autocommands before line 233, the `lazy.nvim` clone/bootstrap at lines 235-244, and `require('lazy').setup(...)` at line 257. Those positions are the baseline behavior contract for this phase. [VERIFIED: codebase grep]

`lazy.nvim` currently documents a structured setup where `init.lua` delegates immediately to a bootstrap module and that module owns the `lazy.nvim` clone, runtimepath prepend, and `require('lazy').setup(...)` call. The same docs explicitly say leader globals must be set before loading `lazy.nvim`, and the Neovim mapping docs state changing `g:mapleader` later does not affect mappings already created. That means the safe Phase 1 move is to extract code around the existing order, not to reshuffle the order itself. [CITED: https://lazy.folke.io/installation] [CITED: https://neovim.io/doc/user/map]

**Primary recommendation:** Keep `init.lua` limited to early globals plus `require('story.bootstrap')`, and move the current lazy bootstrap, base options, early keymaps, and early autocmds behind a single ordered bootstrap module that preserves the existing sequence exactly. [VERIFIED: codebase grep] [CITED: https://lazy.folke.io/installation]

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| Neovim | `0.11+` required by repo; local environment `v0.12.1`; upstream `v0.12.1` released 2026-04-06 | Runtime host for all startup code | Current repo health check hard-requires `0.11+`, and local environment already exceeds that floor. [VERIFIED: codebase grep] [VERIFIED: local command `nvim --version`] [VERIFIED: GitHub release API] |
| `folke/lazy.nvim` | Stable branch in repo bootstrap; latest verified release tag `v11.17.5` published 2025-11-06 | Plugin bootstrap, spec resolution, lazy-loading, runtimepath entry | This is already the repo's plugin manager, and upstream recommends the structured `init.lua -> config.lazy` pattern for modular configs. [VERIFIED: codebase grep] [VERIFIED: `git ls-remote` tags] [VERIFIED: GitHub release API] [CITED: https://lazy.folke.io/installation] |
| Lua module layout under `lua/` | Neovim builtin module loader using `lua/?.lua` and `lua/?/init.lua` conventions | Target location for extracted bootstrap modules | Current repo already uses `lua/kickstart/...` and `lua/custom/...`, so adding a small bootstrap namespace is aligned with existing structure. [VERIFIED: codebase grep] |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| `kickstart.health` module | Current local module in `lua/kickstart/health.lua` | Health parity and external dependency checks | Keep untouched in Phase 1; use it as a smoke-validation target after bootstrap extraction. [VERIFIED: codebase grep] |
| Headless Neovim smoke commands | Works with local `nvim v0.12.1` | Startup validation without a test framework | Use for requirement checks because the repo has no automated test harness today. [VERIFIED: local command `nvim --headless -u ./init.lua +qa`] [VERIFIED: codebase grep] |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Thin `init.lua` + one bootstrap module | Keep all Phase 1 work inline in `init.lua` | Lower churn short-term, but it does not satisfy BOOT-01 and does not create a reusable boundary for Phase 2 and Phase 3. [VERIFIED: requirements] |
| One bootstrap module first | Immediate split into many core modules in Phase 1 | Too much movement at once; increases startup-order regression risk before behavior is isolated. [VERIFIED: roadmap] |

**Installation / verification:**
```bash
git ls-remote --tags --sort='v:refname' https://github.com/folke/lazy.nvim.git | tail -5
curl -s https://api.github.com/repos/folke/lazy.nvim/releases/tags/v11.17.5 | rg 'published_at|tag_name'
curl -s https://api.github.com/repos/neovim/neovim/releases/tags/v0.12.1 | rg 'published_at|tag_name'
```

## Architecture Patterns

### Recommended Project Structure
```text
init.lua                      # early globals + one require only
lua/
├── story/
│   ├── bootstrap.lua         # ordered startup entrypoint
│   ├── core/
│   │   ├── options.lua       # Phase 3 target
│   │   ├── keymaps.lua       # Phase 3 target
│   │   └── autocmds.lua      # Phase 3 target
│   └── util/
│       └── bootstrap.lua     # only if a shared helper becomes necessary
├── kickstart/
│   ├── health.lua
│   └── plugins/
└── custom/
    └── plugins/
```

The key Phase 1 point is not the exact namespace name; it is having one ordered bootstrap module so `init.lua` becomes declarative without scattering startup order across multiple files too early. [VERIFIED: roadmap] [CITED: https://lazy.folke.io/installation]

### Pattern 1: Thin Entrypoint
**What:** `init.lua` should do only the earliest startup assignments and then delegate once. [CITED: https://lazy.folke.io/installation]
**When to use:** Immediately in Phase 1. [VERIFIED: roadmap]
**Example:**
```lua
-- Source pattern: https://lazy.folke.io/installation
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = false

require('story.bootstrap')
```

### Pattern 2: Ordered Bootstrap Module
**What:** The bootstrap module should preserve the existing startup sequence: core always-on config first, `lazy.nvim` path bootstrap second, plugin setup last. [VERIFIED: codebase grep]
**When to use:** Phase 1 extraction; Phase 3 can later split the internal sections into dedicated modules. [VERIFIED: roadmap]
**Example:**
```lua
-- Source basis: current init.lua + https://lazy.folke.io/installation
local M = {}

local function bootstrap_lazy()
  local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', 'https://github.com/folke/lazy.nvim.git', lazypath }
    if vim.v.shell_error ~= 0 then
      error('Error cloning lazy.nvim:\\n' .. out)
    end
  end

  vim.opt.rtp:prepend(lazypath)
end

bootstrap_lazy()
-- require('story.core.options')
-- require('story.core.keymaps')
-- require('story.core.autocmds')
require('lazy').setup({ ... }, { ... })

return M
```

### Pattern 3: Lazy Spec Boundary Stays Data-Oriented
**What:** Keep plugin specs in the `lazy.nvim` setup call or imported plugin modules; do not hide plugin registration behind side-effect-heavy helper code. [CITED: https://lazy.folke.io/usage/structuring]
**When to use:** Phase 1 and Phase 2. [VERIFIED: roadmap]
**Example:**
```lua
require('lazy').setup({
  spec = {
    { import = 'plugins' },
  },
})
```

### Anti-Patterns to Avoid
- **Setting leaders after requiring bootstrap modules:** Neovim resolves `<Leader>` when mappings are created, so moving leader assignment below keymaps will silently change mappings. [CITED: https://neovim.io/doc/user/map]
- **Moving `have_nerd_font` below plugin setup:** Current plugin specs and UI config read `vim.g.have_nerd_font` during `lazy` setup and plugin config. [VERIFIED: codebase grep]
- **Splitting Phase 1 into many modules at once:** Startup order becomes harder to audit, and the roadmap intentionally stages plugin structure and core extraction into later phases. [VERIFIED: roadmap]
- **Changing the `lazy.nvim` bootstrap semantics while refactoring structure:** Keep the clone URL, stable branch, shell error handling, and `rtp:prepend` behavior intact in this phase. [VERIFIED: codebase grep] [CITED: https://lazy.folke.io/installation]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Plugin discovery tree | Custom recursive `require` loader for plugin files | `lazy.nvim` structured setup or `import` support | `lazy.nvim` already supports module-based spec merging and reload behavior. [CITED: https://lazy.folke.io/usage/structuring] |
| Startup validation | Ad hoc shell scripts outside Neovim | Headless `nvim -u ./init.lua` smoke commands | The repo has no test framework, but headless Neovim runs already validate real startup and health code. [VERIFIED: local commands] |
| Runtimepath bootstrap | Custom path mutation helper with extra caching logic | Existing `stdpath('data')` + `rtp:prepend(lazypath)` flow | The current bootstrap already works and matches upstream docs. [VERIFIED: codebase grep] [CITED: https://lazy.folke.io/installation] |

**Key insight:** Phase 1 is about isolating existing behavior, not inventing a new startup system. The safest plan is to wrap the current order in one module boundary first. [VERIFIED: roadmap] [VERIFIED: codebase grep]

## Common Pitfalls

### Pitfall 1: Leader Regression
**What goes wrong:** `<leader>` mappings appear unchanged in code but resolve to the wrong prefix at runtime. [CITED: https://neovim.io/doc/user/map]
**Why it happens:** `g:mapleader` changed after keymaps were already defined. [CITED: https://neovim.io/doc/user/map]
**How to avoid:** Keep `vim.g.mapleader` and `vim.g.maplocalleader` at the top of `init.lua` or above every module that creates mappings. [VERIFIED: codebase grep] [CITED: https://lazy.folke.io/installation]
**Warning signs:** Headless startup prints the expected leader global, but interactive mappings feel wrong; `:map <leader>` output diverges from expectation. [VERIFIED: local command `nvim --headless -u ./init.lua ...`] [ASSUMED]

### Pitfall 2: `have_nerd_font` Read Too Late
**What goes wrong:** Which-key icons, web-devicons enablement, lazy UI icons, and mini statusline icon usage drift from current behavior. [VERIFIED: codebase grep]
**Why it happens:** `vim.g.have_nerd_font` is read in the `lazy` spec table and plugin configs during startup. [VERIFIED: codebase grep]
**How to avoid:** Treat `have_nerd_font` as an early bootstrap global, not a later core option. [VERIFIED: codebase grep]
**Warning signs:** UI icon changes happen without intentional config changes. [ASSUMED]

### Pitfall 3: Runtimepath Mutation Happens Too Late
**What goes wrong:** `require('lazy')` fails or uses a stale plugin manager path. [CITED: https://lazy.folke.io/installation]
**Why it happens:** `vim.opt.rtp:prepend(lazypath)` moved below `require('lazy').setup(...)`. [CITED: https://lazy.folke.io/installation]
**How to avoid:** Keep the clone check and `rtp:prepend` adjacent inside the bootstrap module before any `require('lazy')` call. [VERIFIED: codebase grep] [CITED: https://lazy.folke.io/installation]
**Warning signs:** Immediate startup errors referencing module resolution for `lazy`. [CITED: https://lazy.folke.io/installation]

### Pitfall 4: Phase Boundary Creep
**What goes wrong:** Phase 1 turns into plugin reorganization or options/keymaps extraction, making regressions harder to localize. [VERIFIED: roadmap]
**Why it happens:** Once code is moving, it is tempting to finish later phases early. [ASSUMED]
**How to avoid:** In Phase 1, only establish the skeleton and lift code wholesale into the bootstrap path; defer concern-based reorganization to Phases 2 and 3. [VERIFIED: roadmap]
**Warning signs:** The diff starts creating `lua/plugins/*` or many new core modules before `init.lua` is minimal and stable. [VERIFIED: roadmap]

## Code Examples

Verified patterns from official sources and the current repo:

### Minimal `init.lua`
```lua
-- Source basis: https://lazy.folke.io/installation
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = false

require('story.bootstrap')
```

### Lazy Bootstrap Block
```lua
-- Source basis: current init.lua + https://lazy.folke.io/installation
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\\n' .. out)
  end
end

vim.opt.rtp:prepend(lazypath)
```

### Headless Startup Assertions
```bash
nvim --headless -u ./init.lua "+lua assert(vim.g.mapleader == ' ')" +qa
nvim --headless -u ./init.lua "+checkhealth kickstart" +qa
nvim --headless -u ./init.lua "+Lazy! health" +qa
```

The last two commands were verified locally and exited successfully in this repo on 2026-04-11. [VERIFIED: local commands]

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Single-file Kickstart as the teaching default | Structured `lazy.nvim` setup with `require("config.lazy")` is the documented recommended setup for modular configs | Current docs as crawled in March 2026 | Phase 1 can follow a documented modular pattern without changing plugin manager choice. [CITED: https://lazy.folke.io/installation] |
| Manual `require` calls for each plugin module | `lazy.nvim` supports module-based plugin spec merging and `import` specs | Current docs as crawled in March 2026 | Phase 1 should prepare for Phase 2 by preserving a clean `lazy.setup` boundary. [CITED: https://lazy.folke.io/usage/structuring] |

**Deprecated/outdated:**
- Treating single-file `init.lua` as the only intended structure is outdated for this fork's roadmap, even though upstream Kickstart still documents it as the teaching default. [VERIFIED: roadmap] [VERIFIED: README.md]

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | Interactive mapping drift will be easiest to notice via `:map <leader>` inspection after startup | Common Pitfalls | Low; validation can be adjusted to a different interactive check |
| A2 | UI icon regressions will be visibly noticeable if `have_nerd_font` ordering changes | Common Pitfalls | Low; behavior still remains functionally correct but visual parity may drift |
| A3 | Phase-boundary creep is likely during implementation | Common Pitfalls | Low; this affects planning discipline more than runtime correctness |

## Open Questions

1. **What namespace should own the new bootstrap module?**
   What we know: The repo already has `kickstart` and `custom` namespaces, and Phase 1 needs one new stable namespace for extracted startup code. [VERIFIED: codebase grep]
   What's unclear: Whether the planner should preserve upstream naming or introduce a fork-specific namespace such as `story`. [VERIFIED: codebase grep]
   Recommendation: Pick one namespace in Plan 01-01 and keep all new Phase 1 files under it so future phases do not mix concerns. [VERIFIED: roadmap]

2. **Should always-on options/keymaps/autocmds stay inline in the bootstrap module for Phase 1 or move to placeholder submodules now?**
   What we know: The roadmap reserves dedicated extraction of options, keymaps, and autocommands for Phase 3. [VERIFIED: roadmap]
   What's unclear: Whether creating empty future-facing files in Phase 1 helps or just adds noise. [VERIFIED: roadmap]
   Recommendation: Keep them inline inside the bootstrap module unless a tiny helper is genuinely shared; avoid pre-emptive fragmentation. [VERIFIED: roadmap]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| Neovim | Headless startup validation and runtime host | ✓ | `NVIM v0.12.1` | — |
| Git | `lazy.nvim` first-run clone path | ✓ | `git version 2.53.0` | None; bootstrap clone fails without it |
| `rg` | Existing health expectation and codebase validation | ✓ | `ripgrep 15.1.0` | Manual grep, but health parity changes |
| `make` | Existing health expectation and optional native plugin builds | ✓ | `GNU Make 3.81` | None for plugins that compile native components |
| `unzip` | Existing health expectation | ✓ | `UnZip 6.00` | None for matching current health expectations |

**Missing dependencies with no fallback:**
- None for Phase 1 research and planning. [VERIFIED: local commands]

**Missing dependencies with fallback:**
- None. [VERIFIED: local commands]

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | None detected; use headless Neovim smoke validation. [VERIFIED: codebase grep] |
| Config file | None. [VERIFIED: codebase grep] |
| Quick run command | `nvim --headless -u ./init.lua "+lua assert(vim.g.mapleader == ' ' and vim.g.maplocalleader == ' ' and type(vim.g.have_nerd_font) == 'boolean')" +qa` |
| Full suite command | `nvim --headless -u ./init.lua "+checkhealth kickstart" "+Lazy! health" +qa` |

### Phase Requirements → Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| BOOT-01 | `init.lua` only performs minimal orchestration | manual diff + smoke | `rg -n "mapleader|maplocalleader|have_nerd_font|require\\(" init.lua` | ❌ Wave 0 |
| BOOT-02 | `lazy.nvim` still bootstraps | smoke | `nvim --headless -u ./init.lua "+Lazy! health" +qa` | ✅ command verified |
| BOOT-03 | Early globals and runtimepath order still work | smoke | `nvim --headless -u ./init.lua "+lua assert(vim.g.mapleader == ' ' and vim.g.maplocalleader == ' ')" +qa` | ✅ command verified |

### Sampling Rate
- **Per task commit:** `nvim --headless -u ./init.lua "+lua assert(vim.g.mapleader == ' ' and vim.g.maplocalleader == ' ')" +qa`
- **Per wave merge:** `nvim --headless -u ./init.lua "+checkhealth kickstart" "+Lazy! health" +qa`
- **Phase gate:** Headless checks green and manual inspection confirms `init.lua` is reduced to early globals plus entrypoint(s)

### Wave 0 Gaps
- [ ] No reusable smoke script exists yet; planner should decide whether to add one in Phase 1 or keep commands inline for this phase. [VERIFIED: codebase grep]
- [ ] No automated file-shape check enforces a thin `init.lua`; planner should include a manual verification step. [VERIFIED: codebase grep]

## Security Domain

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|-----------------|
| V2 Authentication | no | Not applicable; local editor config only. [VERIFIED: architecture doc] |
| V3 Session Management | no | Not applicable; local editor config only. [VERIFIED: architecture doc] |
| V4 Access Control | no | Not applicable for this phase's bootstrap refactor. [VERIFIED: architecture doc] |
| V5 Input Validation | yes | Keep explicit error handling around `git clone` bootstrap failure and avoid dynamic `require` names. [VERIFIED: codebase grep] [CITED: https://lazy.folke.io/installation] |
| V6 Cryptography | no | No cryptographic functionality is part of this repo or phase. [VERIFIED: architecture doc] |

### Known Threat Patterns for Neovim bootstrap

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Remote code pulled on first bootstrap via `git clone` | Tampering | Preserve the explicit clone target, stable branch, and fail-fast error path; do not add extra download sources in Phase 1. [VERIFIED: codebase grep] [CITED: https://lazy.folke.io/installation] |
| Startup regression hidden behind lazy-loading side effects | Tampering | Keep Phase 1 changes structural and validate with headless startup plus health checks after each extraction step. [VERIFIED: roadmap] [VERIFIED: local commands] |
| Unintended module execution order changes | Elevation of Privilege / Tampering | Use one ordered bootstrap module first; defer deeper module fan-out until later phases. [VERIFIED: roadmap] |

## Sources

### Primary (HIGH confidence)
- Current repo `init.lua`, `lua/kickstart/health.lua`, `.planning/REQUIREMENTS.md`, `.planning/ROADMAP.md`, `.planning/codebase/*.md` - startup order, phase scope, existing health/runtime behavior. [VERIFIED: codebase grep]
- https://lazy.folke.io/installation - recommended structured setup, bootstrap snippet, leader ordering guidance. [CITED: https://lazy.folke.io/installation]
- https://lazy.folke.io/usage/structuring - plugin spec import and module-merging behavior. [CITED: https://lazy.folke.io/usage/structuring]
- https://neovim.io/doc/user/map - `mapleader` behavior and the fact that changing it later does not affect existing mappings. [CITED: https://neovim.io/doc/user/map]
- GitHub release/tag verification for `folke/lazy.nvim` and `neovim/neovim` via GitHub API and `git ls-remote`. [VERIFIED: GitHub release API] [VERIFIED: `git ls-remote` tags]

### Secondary (MEDIUM confidence)
- https://github.com/nvim-lua/kickstart.nvim/pull/473 - evidence that multi-file restructuring is an active upstream discussion/reference point. [VERIFIED: GitHub API]
- `README.md` FAQ link to `kickstart-modular.nvim` - confirms modularization is already acknowledged by upstream docs. [VERIFIED: README.md]

### Tertiary (LOW confidence)
- None.

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - core runtime and plugin manager are already present in the repo and current versions were verified live.
- Architecture: HIGH - startup order and phase boundaries are explicit in the current code and roadmap, and `lazy.nvim` has current official guidance for the target pattern.
- Pitfalls: MEDIUM - the critical ones are directly verified, while some warning-sign descriptions remain observational rather than formally documented.

**Research date:** 2026-04-11
**Valid until:** 2026-05-11
