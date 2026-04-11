# Phase 04: Compatibility and Cleanup - Research

**Researched:** 2026-04-11
**Domain:** Neovim config compatibility, `lazy.nvim` spec composition, and parity validation
**Confidence:** HIGH

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
### Optional Module Entry Points
- **D-01:** `lua/custom/plugins/` remains the stable user extension path in the modular architecture.
- **D-02:** `lua/kickstart/plugins/` should remain available only as legacy/example modules rather than a first-class active plugin namespace.
- **D-03:** Phase 4 may add compatibility support for optional/example modules if needed, but should not require users to move custom plugin files out of `lua/custom/plugins/`.

### Legacy Branding And Health Surface
- **D-04:** Phase 4 should keep existing Kickstart-facing module names and user-visible health messages rather than renaming them now.
- **D-05:** Branding cleanup is explicitly deferred; compatibility work should not introduce avoidable path or message churn in health-related surfaces.

### Parity Sign-Off Bar
- **D-06:** Phase 4 requires strict parity for the core interactive workflows called out in the roadmap, not just startup sanity.
- **D-07:** Telescope, LSP attach behavior, completion, formatting, Treesitter, health checks, and optional plugin-module behavior are all phase-blocking validation targets.

### Cleanup Strictness
- **D-08:** Cleanup should remove only clearly dead or duplicate runtime/startup paths.
- **D-09:** Harmless transitional scaffolding or comments can remain if removing them is not necessary to eliminate duplication or obsolete behavior.

### the agent's Discretion
- Exact compatibility mechanism for legacy/example `kickstart.plugins` modules, provided `custom.plugins` remains the stable user path and no new active shipped-plugin source of truth is introduced outside `lua/plugins/`.
- Exact validation approach for proving parity across the required interactive workflows.
- Which comments or transitional guidance count as harmless scaffolding versus dead or duplicate behavior that must be removed.

### Deferred Ideas (OUT OF SCOPE)
- Broad StoryNvim rebranding of module names, health output, and user-facing messages — defer to a later phase rather than mixing it into compatibility work.
- Broad polish-oriented trimming of comments or instructional scaffolding that is not clearly dead or duplicate behavior.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| PLUG-03 | Existing optional plugin modules remain compatible or are migrated consistently into the new structure [VERIFIED: .planning/REQUIREMENTS.md] | Keep `lua/plugins` as the only shipped source, preserve `kickstart.plugins.*` as explicit legacy/example specs, and validate `custom.plugins` plus all legacy modules through real headless loads [VERIFIED: .planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md] [VERIFIED: nvim --headless] [CITED: https://lazy.folke.io/spec] |
| PAR-01 | Core editing behavior remains unchanged from the user perspective after the migration [VERIFIED: .planning/REQUIREMENTS.md] | Use parity checks that cover startup, keymaps, autocmds, clipboard scheduling, and health without broad feature churn [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: lua/core/*.lua] [VERIFIED: nvim --headless] |
| PAR-02 | LSP, completion, formatting, Treesitter, and Telescope still load and work after the migration [VERIFIED: .planning/REQUIREMENTS.md] | Combine `lazy` registry assertions, event-triggered headless checks, and short manual UAT for true interactive behavior [VERIFIED: lua/plugins/*.lua] [VERIFIED: nvim --headless] |
| PAR-03 | Health checks and optional plugin modules still load correctly after the migration [VERIFIED: .planning/REQUIREMENTS.md] | Preserve `kickstart` health naming and require all optional modules directly in the validation suite [VERIFIED: lua/kickstart/health.lua] [VERIFIED: lua/kickstart/plugins/*.lua] [VERIFIED: nvim --headless] |
</phase_requirements>

## Summary

Phase 4 should treat compatibility as a contract problem, not a restructuring opportunity. The current runtime already has one canonical shipped plugin source, `spec = { { import = 'plugins' } }`, while `kickstart.plugins.*` remains commented guidance and `custom.plugins` exists as the user extension namespace. Planning should preserve that shape instead of introducing a second active shipped namespace. [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: lua/custom/plugins/init.lua] [VERIFIED: .planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md]

The safest compatibility mechanism is: keep `lua/plugins` as the only active shipped source; keep `lua/kickstart/plugins/*.lua` as explicit legacy/example specs that users opt into individually; and make Phase 4 prove those modules still compose cleanly with the modular layout. This matches the locked decisions and `lazy.nvim`’s documented spec-import and spec-merge behavior. [VERIFIED: .planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md] [CITED: https://lazy.folke.io/spec]

Validation has to be event-aware. Plain headless startup is not enough for VimEnter-lazy-loaded workflows like Telescope keymaps; the checks need to trigger the relevant lazy-load events before asserting behavior. The current machine can run those checks with `nvim --headless`, and the repo already passes direct headless loads for all legacy modules plus `checkhealth kickstart`. [VERIFIED: nvim --headless] [VERIFIED: .planning/config.json]

**Primary recommendation:** Keep `lua/plugins` as the only shipped plugin source, preserve `kickstart.plugins.*` as explicit legacy overlays/examples, and make Phase 4 deliver an event-aware headless parity suite plus a short manual UAT checklist. [VERIFIED: .planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md] [CITED: https://lazy.folke.io/spec]

## Project Constraints (from CLAUDE.md)

No `CLAUDE.md` file exists at the repository root, so there are no additional project-local directives beyond the phase context and planning documents. [VERIFIED: repo root ls]

## Standard Stack

### Core

| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| Neovim | `0.11+` required by health check; local machine `0.12.1` [VERIFIED: lua/kickstart/health.lua] [VERIFIED: nvim --version] | Runtime and validation target [VERIFIED: .planning/codebase/STACK.md] | All startup, health, and parity checks execute through the real repo entrypoint `init.lua`. [VERIFIED: init.lua] |
| `lazy.nvim` | `stable` branch bootstrap [VERIFIED: lua/story/bootstrap/lazy.lua] | Plugin manager and spec composition [VERIFIED: .planning/codebase/STACK.md] | The codebase already uses imports as the canonical shipped plugin source. [VERIFIED: lua/story/bootstrap.lua] |
| `lua/plugins` imports | current shipped source of truth [VERIFIED: lua/story/bootstrap.lua] | Active shipped plugin specs grouped by concern [VERIFIED: lua/plugins/*.lua] | This is the locked architecture from earlier phases and must not be displaced in Phase 4. [VERIFIED: .planning/PROJECT.md] [VERIFIED: .planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md] |

### Supporting

| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| `kickstart.plugins.*` modules | legacy/example spec files [VERIFIED: lua/kickstart/plugins/*.lua] | Opt-in optional modules and compatibility surface [VERIFIED: .planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md] | Keep them as individually required examples or overlays; do not mass-import them as a new active namespace. [VERIFIED: .planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md] |
| `custom.plugins` | empty `LazySpec` stub today [VERIFIED: lua/custom/plugins/init.lua] | Stable user-owned extension path [VERIFIED: .planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md] | Use for user customizations without forcing moves away from `lua/custom/plugins/`. [VERIFIED: .planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md] |
| `vim.health` | built-in Neovim health API [VERIFIED: lua/kickstart/health.lua] | Health compatibility and environment diagnostics [VERIFIED: .planning/codebase/CONVENTIONS.md] | Keep current Kickstart-facing health surface intact in this phase. [VERIFIED: .planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Single shipped source `lua/plugins` [VERIFIED: lua/story/bootstrap.lua] | Import `kickstart.plugins` as a second active namespace [ASSUMED] | Reject this. It violates the phase decisions and would create two active sources of truth for shipped behavior. [VERIFIED: .planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md] |
| Explicit legacy optional modules [VERIFIED: lua/story/bootstrap.lua] | Rewrite all legacy modules into `lua/plugins` now [ASSUMED] | Reject this in Phase 4 unless a specific module is truly incompatible. Broad migration adds churn and obscures parity regressions. [VERIFIED: .planning/PROJECT.md] [VERIFIED: .planning/ROADMAP.md] |

**Installation:**

No new package manager or library installation should be part of Phase 4. The phase should run against the existing Neovim runtime and repo-local modules. [VERIFIED: .planning/PROJECT.md] [VERIFIED: .planning/ROADMAP.md]

**Version verification:** This phase is a brownfield compatibility pass over repo-managed Neovim plugin specs, not an npm-based dependency selection phase. The relevant version constraints are the repo’s existing plugin specs and the local Neovim runtime. [VERIFIED: lua/plugins/coding.lua] [VERIFIED: lua/story/bootstrap/lazy.lua] [VERIFIED: nvim --version]

## Architecture Patterns

### Recommended Project Structure

```text
init.lua                     # Minimal entrypoint, unchanged for Phase 4
lua/story/bootstrap.lua      # Canonical startup orchestrator and compatibility seam
lua/story/bootstrap/lazy.lua # lazy.nvim bootstrap helper
lua/plugins/*.lua            # Only active shipped plugin source
lua/kickstart/plugins/*.lua  # Legacy/example optional specs
lua/custom/plugins/*.lua     # Stable user extension path
lua/core/*.lua               # Always-on editor behavior extracted in Phase 3
```

Structure above reflects the current codebase and the locked Phase 4 decisions. [VERIFIED: init.lua] [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: lua/core/*.lua] [VERIFIED: .planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md]

### Pattern 1: One Active Shipped Plugin Source

**What:** Keep `require('lazy').setup({ spec = { { import = 'plugins' } }, ... })` as the only active shipped plugin source. Legacy/example modules stay opt-in rather than becoming a second imported tree. [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: .planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md]

**When to use:** Always, for any cleanup or compatibility change in Phase 4. [VERIFIED: .planning/ROADMAP.md]

**Example:**

```lua
-- Source: lua/story/bootstrap.lua + https://lazy.folke.io/spec
require('lazy').setup({
  spec = { { import = 'plugins' } },

  -- Legacy/example modules remain explicit opt-ins.
  -- require 'kickstart.plugins.debug'
  -- require 'kickstart.plugins.lint'
  -- require 'kickstart.plugins.gitsigns'
  -- { import = 'custom.plugins' },
})
```

The `import` field is documented by `lazy.nvim`; the current bootstrap already uses it. [VERIFIED: lua/story/bootstrap.lua] [CITED: https://lazy.folke.io/spec]

### Pattern 2: Use Legacy Modules as Overlays or Standalone Opt-Ins

**What:** Legacy modules should either add a standalone optional plugin (`debug`, `lint`, `autopairs`, `indent_line`, `neo-tree`) or layer onto an already-shipped plugin (`gitsigns`). `lazy.nvim` documents that parent/child specs merge `opts`, and optional scoped specs exist for distro-style composition. [VERIFIED: lua/kickstart/plugins/*.lua] [CITED: https://lazy.folke.io/spec]

**When to use:** When reconciling each `lua/kickstart/plugins/*.lua` file with the new modular layout. [VERIFIED: .planning/ROADMAP.md]

**Example:**

```lua
-- Source: lua/kickstart/plugins/gitsigns.lua + https://lazy.folke.io/spec
return {
  'lewis6991/gitsigns.nvim',
  opts = {
    on_attach = function(bufnr)
      local gitsigns = require 'gitsigns'
      vim.keymap.set('n', ']c', function() gitsigns.nav_hunk 'next' end, { buffer = bufnr })
    end,
  },
}
```

This file is compatible with the active shipped `gitsigns.nvim` spec because the plugin identity matches and `opts` are designed to compose. [VERIFIED: lua/plugins/editor.lua] [VERIFIED: lua/kickstart/plugins/gitsigns.lua] [CITED: https://lazy.folke.io/spec]

### Pattern 3: Event-Aware Headless Parity Checks

**What:** Trigger the lazy-load event before asserting event-bound behavior. Telescope and which-key are `event = 'VimEnter'`; Conform loads on `BufWritePre`. [VERIFIED: lua/plugins/telescope.lua] [VERIFIED: lua/plugins/editor.lua] [VERIFIED: lua/plugins/lsp.lua]

**When to use:** Any automated parity check that inspects keymaps, plugin availability, or lazy-loaded modules. [VERIFIED: nvim --headless]

**Example:**

```bash
# Source: current repo behavior validated in headless Neovim
nvim --headless -u ./init.lua \
  "+doautocmd VimEnter" \
  "+lua vim.wait(400); assert(vim.fn.maparg('<leader>sh','n',false,true).lhs == '<Space>sh')" \
  "+checkhealth kickstart" +qa
```

Without the event trigger, the Telescope keymap assertion fails in headless mode. With `doautocmd VimEnter`, it passes. [VERIFIED: nvim --headless]

### Anti-Patterns to Avoid

- **Mass-importing `kickstart.plugins`:** This would create a second active plugin namespace and violate the locked architecture. [VERIFIED: .planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md]
- **Testing lazy-loaded workflows without firing their load events:** Plain headless startup missed Telescope keymaps until `VimEnter` was triggered. [VERIFIED: nvim --headless]
- **Removing the second `vim.opt.rtp:prepend(config_root)` blindly:** Phase 3 already recorded that repo-entrypoint headless checks depended on reapplying repo runtimepath after `lazy.setup(...)`. [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: .planning/STATE.md]
- **Broad cleanup of comments or branding in this phase:** That scope is explicitly deferred. [VERIFIED: .planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Plugin composition | A custom compatibility loader for optional modules [ASSUMED] | `lazy.nvim` imports and duplicate-spec merging [CITED: https://lazy.folke.io/spec] | The plugin manager already supports imported spec modules and merged `opts`; custom loaders would add ordering risk. [CITED: https://lazy.folke.io/spec] |
| Health diagnostics | A bespoke status command [ASSUMED] | `vim.health` and `:checkhealth kickstart` [VERIFIED: lua/kickstart/health.lua] | Existing health output is already the user-visible compatibility surface and is locked to stay stable in this phase. [VERIFIED: .planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md] |
| Parity smoke harness | Ad hoc shell greps only [ASSUMED] | `nvim --headless -u ./init.lua` with real runtime assertions [VERIFIED: nvim --headless] | The risk is behavioral regression, so the checks must exercise the real entrypoint and lazy-load events. [VERIFIED: .planning/ROADMAP.md] |

**Key insight:** Phase 4 should reuse existing composition and health mechanisms, then tighten validation around them. The risk is runtime drift, not missing abstraction. [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: lua/kickstart/health.lua] [VERIFIED: nvim --headless]

## Common Pitfalls

### Pitfall 1: Turning Legacy Modules into a Second Active Source of Truth

**What goes wrong:** `lua/kickstart/plugins/` starts behaving like another shipped plugin tree instead of explicit example/legacy modules. [VERIFIED: .planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md]

**Why it happens:** The files already return valid `LazySpec` tables, so importing them wholesale is mechanically easy. [VERIFIED: lua/kickstart/plugins/*.lua]

**How to avoid:** Keep the active shipped path in `lua/plugins/`; reconcile each legacy module individually as either a standalone optional module or an overlay. [VERIFIED: lua/story/bootstrap.lua] [CITED: https://lazy.folke.io/spec]

**Warning signs:** New bootstrap imports point at `kickstart.plugins`, or the plan starts talking about two active plugin namespaces. [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: .planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md]

### Pitfall 2: False Positives from Headless Checks

**What goes wrong:** Automated checks report parity even though VimEnter-lazy-loaded workflows were never exercised. [VERIFIED: nvim --headless]

**Why it happens:** Telescope and which-key load on `VimEnter`, and Conform loads on `BufWritePre`. [VERIFIED: lua/plugins/telescope.lua] [VERIFIED: lua/plugins/editor.lua] [VERIFIED: lua/plugins/lsp.lua]

**How to avoid:** Fire the relevant autocommand before asserting maps or modules, and keep a short manual UAT pass for truly interactive workflows. [VERIFIED: nvim --headless]

**Warning signs:** `maparg('<leader>sh')` is empty in CI or headless verification, but works after `doautocmd VimEnter`. [VERIFIED: nvim --headless]

### Pitfall 3: Cleanup That Removes Compatibility-Critical Runtime Helpers

**What goes wrong:** The repo looks cleaner but loses headless repo-entrypoint compatibility or existing startup order. [VERIFIED: .planning/STATE.md]

**Why it happens:** `lua/story/bootstrap.lua` still owns runtime-sensitive behavior, including repo runtimepath handling before and after `lazy.setup(...)` and scheduled clipboard setup. [VERIFIED: lua/story/bootstrap.lua]

**How to avoid:** Only remove code proven dead or duplicate; keep runtime helpers until a real headless assertion proves they are redundant. [VERIFIED: .planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md] [VERIFIED: nvim --headless]

**Warning signs:** The cleanup diff deletes runtimepath or bootstrap lines without adding a replacement assertion. [VERIFIED: lua/story/bootstrap.lua]

## Code Examples

Verified patterns from official sources and the current codebase:

### Canonical Bootstrap Spec Boundary

```lua
-- Source: lua/story/bootstrap.lua + https://lazy.folke.io/spec
require('lazy').setup({
  spec = { { import = 'plugins' } },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      plugin = '🔌',
      lazy = '💤 ',
    },
  },
})
```

`lazy.nvim` documents `import` as a first-class spec feature; the repo already uses it as the active source boundary. [VERIFIED: lua/story/bootstrap.lua] [CITED: https://lazy.folke.io/spec]

### Repeatable Headless Compatibility Check

```bash
# Source: validated on the local machine with the current repo
nvim --headless -u ./init.lua \
  "+doautocmd VimEnter" \
  "+lua vim.wait(500); \
    local cfg=require('lazy.core.config'); \
    for _,name in ipairs({'telescope.nvim','nvim-lspconfig','blink.cmp','conform.nvim','nvim-treesitter','gitsigns.nvim'}) do assert(cfg.plugins[name], name) end; \
    assert(type(require('kickstart.plugins.debug'))=='table'); \
    assert(type(require('kickstart.plugins.lint'))=='table'); \
    assert(type(require('kickstart.plugins.gitsigns'))=='table'); \
    assert(type(require('kickstart.plugins.autopairs'))=='table'); \
    assert(type(require('kickstart.plugins.indent_line'))=='table'); \
    assert(type(require('kickstart.plugins.neo-tree'))=='table'); \
    assert(type(require('custom.plugins'))=='table'); \
    assert(vim.fn.maparg('<leader>sh','n',false,true).lhs == '<Space>sh'); \
    assert(vim.o.clipboard == 'unnamedplus')" \
  "+checkhealth kickstart" +qa
```

This command exercises the real entrypoint, lazy registry, legacy modules, a VimEnter-bound Telescope mapping, clipboard scheduling, and health. [VERIFIED: nvim --headless]

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Shipped plugins declared inline in the startup file [VERIFIED: .planning/PROJECT.md] | Shipped plugins imported from concern modules under `lua/plugins` [VERIFIED: lua/story/bootstrap.lua] | Phase 2 on 2026-04-11 [VERIFIED: .planning/ROADMAP.md] | Phase 4 must preserve this as the only active shipped source. [VERIFIED: .planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md] |
| Always-on editor behavior mixed into bootstrap [VERIFIED: .planning/PROJECT.md] | Always-on behavior extracted to `lua/core/*`, with bootstrap retaining runtime-sensitive helpers [VERIFIED: lua/core/*.lua] [VERIFIED: lua/story/bootstrap.lua] | Phase 3 on 2026-04-11 [VERIFIED: .planning/STATE.md] | Cleanup has to distinguish genuinely dead bootstrap code from runtime-critical glue. [VERIFIED: .planning/STATE.md] |
| Optional modules were documented as comment-uncomment examples [VERIFIED: init.lua historical comments preserved in lua/story/bootstrap.lua] | Optional modules are still example/legacy modules, but now must be validated against a modular shipped layout [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: .planning/ROADMAP.md] | Phase 4 target [VERIFIED: .planning/ROADMAP.md] | Compatibility proof matters more than relocating them. [VERIFIED: .planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md] |

**Deprecated/outdated:**

- Treating plain startup smoke as sufficient parity evidence is outdated for this repo after the move to lazy imports and extracted core modules. Event-aware headless checks are now the minimum useful automation. [VERIFIED: lua/plugins/telescope.lua] [VERIFIED: nvim --headless]

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | Importing `kickstart.plugins` as a second active namespace would be mechanically possible but architecturally wrong. [ASSUMED] | Standard Stack / Common Pitfalls | Low. The planner should still reject it because the locked decisions already forbid it. |
| A2 | Rewriting all legacy modules into `lua/plugins` during Phase 4 would add unnecessary churn in most cases. [ASSUMED] | Standard Stack | Medium. If a legacy module is structurally incompatible, the plan may need a targeted migration task. |
| A3 | A custom compatibility loader would be worse than using `lazy.nvim` composition. [ASSUMED] | Don't Hand-Roll | Medium. If the repo exposes an undocumented edge case, the plan may need a thinner adapter than expected. |

## Open Questions

1. **Should Phase 4 uncomment `{ import = 'custom.plugins' }` permanently or only validate that it can be enabled safely?**
   What we know: `lua/custom/plugins/init.lua` exists and returns an empty `LazySpec`, and Phase 4 decisions lock `custom.plugins` as the stable user extension path. [VERIFIED: lua/custom/plugins/init.lua] [VERIFIED: .planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md]
   What's unclear: The current bootstrap still leaves that import commented, so enabling it by default is an implementation choice, not an already-validated contract. [VERIFIED: lua/story/bootstrap.lua]
   Recommendation: Plan for an explicit decision early in 04-01. If enabled, verify it through the full headless suite and keep it low-risk by preserving the empty stub. [VERIFIED: lua/custom/plugins/init.lua] [VERIFIED: nvim --headless]

2. **Which legacy modules need adapter work versus simple validation?**
   What we know: `debug`, `lint`, `autopairs`, `indent_line`, and `neo-tree` are standalone optional specs, while `gitsigns` layers onto a plugin already shipped from `lua/plugins/editor.lua`. [VERIFIED: lua/kickstart/plugins/*.lua] [VERIFIED: lua/plugins/editor.lua]
   What's unclear: Whether any of those specs depend on pre-Phase-3 assumptions that only show up when they are actually enabled. [VERIFIED: .planning/STATE.md]
   Recommendation: Audit each legacy module individually in 04-01 and treat `gitsigns` as the highest-value merge-composition check. [VERIFIED: lua/kickstart/plugins/gitsigns.lua] [CITED: https://lazy.folke.io/spec]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| Neovim | All runtime validation [VERIFIED: .planning/ROADMAP.md] | ✓ [VERIFIED: nvim --version] | `0.12.1` [VERIFIED: nvim --version] | — |
| `git` | `lazy.nvim` bootstrap and health [VERIFIED: lua/story/bootstrap/lazy.lua] [VERIFIED: lua/kickstart/health.lua] | ✓ [VERIFIED: git --version] | `2.53.0` [VERIFIED: git --version] | — |
| `make` | `telescope-fzf-native.nvim` build and some optional plugin installs [VERIFIED: lua/plugins/telescope.lua] [VERIFIED: lua/plugins/coding.lua] | ✓ [VERIFIED: make --version] | `GNU Make 3.81` [VERIFIED: make --version] | `telescope-fzf-native.nvim` is already guarded by `cond`; validation can still proceed without native build if required. [VERIFIED: lua/plugins/telescope.lua] |
| `unzip` | Health expectations [VERIFIED: lua/kickstart/health.lua] | ✓ via passing `checkhealth kickstart` [VERIFIED: nvim --headless] | — | — |
| `rg` | Telescope live grep and health expectations [VERIFIED: lua/kickstart/health.lua] [VERIFIED: .planning/codebase/INTEGRATIONS.md] | ✓ [VERIFIED: rg --version] | `15.1.0` [VERIFIED: rg --version] | No good fallback for parity of live grep itself. |
| `stylua` CLI | Optional local formatting verification [VERIFIED: .planning/codebase/STACK.md] | ✗ [VERIFIED: command -v stylua] | — | Rely on code review plus CI formatting checks; do not make local `stylua` a blocking assumption in the plan. [VERIFIED: .github/workflows/stylua.yml] |

**Missing dependencies with no fallback:**

- None for Phase 4 research and parity validation. Core runtime checks can run on this machine. [VERIFIED: nvim --headless]

**Missing dependencies with fallback:**

- `stylua` CLI is missing locally, but this phase can still validate behavior through headless Neovim and leave formatting enforcement to CI. [VERIFIED: command -v stylua] [VERIFIED: .github/workflows/stylua.yml]

## Validation Architecture

### Test Framework

| Property | Value |
|----------|-------|
| Framework | No formal test framework; use repeatable `nvim --headless -u ./init.lua` smoke assertions plus manual UAT for interactive parity. [VERIFIED: repo test scan] [VERIFIED: nvim --headless] |
| Config file | none — no `pytest`, `jest`, or `vitest` config detected. [VERIFIED: repo test scan] |
| Quick run command | `nvim --headless -u ./init.lua "+checkhealth kickstart" +qa` [VERIFIED: nvim --headless] |
| Full suite command | `nvim --headless -u ./init.lua "+doautocmd VimEnter" "+lua vim.wait(500); local cfg=require('lazy.core.config'); for _,name in ipairs({'telescope.nvim','nvim-lspconfig','blink.cmp','conform.nvim','nvim-treesitter','gitsigns.nvim'}) do assert(cfg.plugins[name], name) end; assert(type(require('kickstart.plugins.debug'))=='table'); assert(type(require('kickstart.plugins.lint'))=='table'); assert(type(require('kickstart.plugins.gitsigns'))=='table'); assert(type(require('kickstart.plugins.autopairs'))=='table'); assert(type(require('kickstart.plugins.indent_line'))=='table'); assert(type(require('kickstart.plugins.neo-tree'))=='table'); assert(type(require('custom.plugins'))=='table'); assert(vim.fn.maparg('<leader>sh','n',false,true).lhs == '<Space>sh'); assert(vim.fn.maparg('<leader><leader>','n',false,true).lhs == '<Space><Space>'); local ac=vim.api.nvim_get_autocmds({group='kickstart-highlight-yank'}); assert(#ac > 0); assert(vim.o.clipboard == 'unnamedplus')" "+checkhealth kickstart" +qa` [VERIFIED: nvim --headless] |

### Phase Requirements → Test Map

| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| PLUG-03 | Legacy `kickstart.plugins.*` modules and `custom.plugins` still resolve under the modular layout. [VERIFIED: .planning/REQUIREMENTS.md] | smoke | Full suite command above; it directly requires all legacy modules and `custom.plugins`. [VERIFIED: nvim --headless] | ✅ |
| PAR-01 | Core startup behavior and always-on editor setup still initialize correctly. [VERIFIED: .planning/REQUIREMENTS.md] | smoke | `nvim --headless -u ./init.lua "+lua vim.wait(400); local ac=vim.api.nvim_get_autocmds({group='kickstart-highlight-yank'}); assert(#ac>0); assert(vim.o.clipboard=='unnamedplus')" "+checkhealth kickstart" +qa` [VERIFIED: nvim --headless] | ✅ |
| PAR-02 | LSP, completion, formatting, Treesitter, and Telescope still load under the new structure. [VERIFIED: .planning/REQUIREMENTS.md] | hybrid smoke + manual | Automated: full suite plus `"+doautocmd BufWritePre" "+lua vim.wait(400); assert(pcall(require,'conform'))"` and `"+lua vim.wait(500); local ac=vim.api.nvim_get_autocmds({event='LspAttach'}); assert(#ac>0)"`. Manual: open a Lua buffer and verify Telescope, completion menu, formatting, Treesitter highlight, and LSP attach mappings. [VERIFIED: nvim --headless] [VERIFIED: lua/plugins/*.lua] | ✅ / manual |
| PAR-03 | Health checks and optional modules still work without path/message churn. [VERIFIED: .planning/REQUIREMENTS.md] | smoke | `nvim --headless -u ./init.lua "+checkhealth kickstart" +qa` and full suite legacy-module requires. [VERIFIED: nvim --headless] | ✅ |

### Sampling Rate

- **Per task commit:** `nvim --headless -u ./init.lua "+checkhealth kickstart" +qa` [VERIFIED: nvim --headless]
- **Per wave merge:** Run the full suite command plus a 5-minute manual UAT pass for Telescope, LSP attach, completion, formatting, and Treesitter. [VERIFIED: .planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md]
- **Phase gate:** Full suite green and manual parity checklist completed before `/gsd-verify-work`. [VERIFIED: .planning/config.json]

### Wave 0 Gaps

- None in tooling. The repo has no formal test framework, but the headless validation strategy is concrete and executable on this machine. [VERIFIED: repo test scan] [VERIFIED: nvim --headless]
- Manual UAT remains necessary for true interactive parity because headless automation cannot fully prove picker UX, popup completion feel, or visible Treesitter highlighting behavior. [VERIFIED: lua/plugins/telescope.lua] [VERIFIED: lua/plugins/coding.lua]

## Security Domain

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|-----------------|
| V2 Authentication | no [VERIFIED: .planning/codebase/INTEGRATIONS.md] | Not applicable to this local editor config. [VERIFIED: .planning/codebase/INTEGRATIONS.md] |
| V3 Session Management | no [VERIFIED: .planning/codebase/INTEGRATIONS.md] | Not applicable to this local editor config. [VERIFIED: .planning/codebase/INTEGRATIONS.md] |
| V4 Access Control | no [VERIFIED: .planning/codebase/INTEGRATIONS.md] | Not applicable to this local editor config. [VERIFIED: .planning/codebase/INTEGRATIONS.md] |
| V5 Input Validation | yes [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: lua/kickstart/health.lua] | Preserve existing guarded conditions, health checks, and explicit runtime assertions instead of adding ad hoc loaders. [VERIFIED: lua/plugins/telescope.lua] [VERIFIED: lua/kickstart/health.lua] |
| V6 Cryptography | no [VERIFIED: .planning/codebase/INTEGRATIONS.md] | Not applicable in this phase. [VERIFIED: .planning/codebase/INTEGRATIONS.md] |

### Known Threat Patterns for This Stack

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Plugin source or bootstrap drift | Tampering | Keep the existing `lazy.nvim` bootstrap remote/branch/error path unchanged while doing compatibility cleanup. [VERIFIED: lua/story/bootstrap/lazy.lua] |
| Runtimepath shadowing or repo-entrypoint breakage | Tampering / Elevation | Preserve and re-verify explicit repo root `rtp:prepend` behavior before and after `lazy.setup(...)`. [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: nvim --headless] |
| Hidden regression behind lazy events | Denial of Service | Use event-aware headless checks and manual UAT instead of startup-only smoke. [VERIFIED: nvim --headless] |

## Sources

### Primary (HIGH confidence)

- `lua/story/bootstrap.lua` - active `lazy.setup(...)` boundary, legacy/example comments, runtimepath handling, clipboard scheduling. [VERIFIED: codebase grep]
- `lua/story/bootstrap/lazy.lua` - `lazy.nvim` bootstrap remote, stable branch, and runtimepath prepend. [VERIFIED: codebase grep]
- `lua/plugins/telescope.lua`, `lua/plugins/lsp.lua`, `lua/plugins/coding.lua`, `lua/plugins/editor.lua`, `lua/plugins/ui.lua` - current shipped plugin behavior and lazy-load events. [VERIFIED: codebase grep]
- `lua/kickstart/health.lua` and `lua/kickstart/plugins/*.lua` - health surface and legacy/example optional modules. [VERIFIED: codebase grep]
- `.planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md`, `.planning/REQUIREMENTS.md`, `.planning/ROADMAP.md`, `.planning/STATE.md` - locked decisions, requirement scope, success criteria, and recorded runtimepath risk. [VERIFIED: codebase grep]
- Local headless validation commands run on 2026-04-11 - direct proof that `checkhealth kickstart`, legacy module `require(...)`, lazy registry checks, and event-triggered map assertions work on this machine. [VERIFIED: nvim --headless]

### Secondary (MEDIUM confidence)

- `https://lazy.folke.io/spec` - official `lazy.nvim` documentation for `import`, spec composition, `optional`, and `opts` merging. [CITED: https://lazy.folke.io/spec]

### Tertiary (LOW confidence)

- None.

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - the active architecture, plugin boundaries, and runtime behavior were read directly from the repo and exercised with headless Neovim. [VERIFIED: codebase grep] [VERIFIED: nvim --headless]
- Architecture: HIGH - the phase decisions are explicit, and the compatibility seam is concentrated in `lua/story/bootstrap.lua`. [VERIFIED: .planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md] [VERIFIED: lua/story/bootstrap.lua]
- Pitfalls: HIGH - the main failure modes were either already recorded in planning state or reproduced during headless validation. [VERIFIED: .planning/STATE.md] [VERIFIED: nvim --headless]

**Research date:** 2026-04-11
**Valid until:** 2026-05-11
