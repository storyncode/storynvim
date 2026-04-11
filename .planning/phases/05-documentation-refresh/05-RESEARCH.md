# Phase 05: Documentation Refresh - Research

**Researched:** 2026-04-11
**Domain:** Documentation alignment for a modular Neovim config fork
**Confidence:** HIGH

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
- **D-01:** The repo should now describe itself as a modular personal or forkable Neovim configuration, not as an intentionally single-file teaching config. [VERIFIED: .planning/phases/05-documentation-refresh/05-CONTEXT.md]
- **D-02:** Documentation should explain the current architecture in terms of the actual module layout (`init.lua`, `lua/story`, `lua/core`, `lua/plugins`, `lua/custom`) instead of preserving outdated historical framing. [VERIFIED: .planning/phases/05-documentation-refresh/05-CONTEXT.md]
- **D-03:** `README.md` should clearly point users to `lua/plugins/` for shipped plugin behavior, `lua/core/` for always-on editor behavior, and `lua/custom/plugins/` for fork-local extension. [VERIFIED: .planning/phases/05-documentation-refresh/05-CONTEXT.md]
- **D-04:** Legacy `lua/kickstart/plugins/` modules should be documented as compatibility or example paths rather than the main active customization route. [VERIFIED: .planning/phases/05-documentation-refresh/05-CONTEXT.md]
- **D-05:** The documentation refresh should stay structural and practical: explain what changed, where things live, and how to customize safely without turning the phase into a broader product rewrite. [VERIFIED: .planning/phases/05-documentation-refresh/05-CONTEXT.md]
- **D-06:** Existing installation and dependency guidance can stay where still accurate, but any text that depends on the old single-file model should be updated or removed. [VERIFIED: .planning/phases/05-documentation-refresh/05-CONTEXT.md]

### Claude's Discretion
- Exact README structure, section ordering, and how much historical context to retain, as long as the active architecture and customization paths become obvious. [VERIFIED: .planning/phases/05-documentation-refresh/05-CONTEXT.md]
- Whether to add a concise architecture map, migration notes, or file-tree examples if they improve clarity without bloating the docs. [VERIFIED: .planning/phases/05-documentation-refresh/05-CONTEXT.md]
- Which remaining inline or help-doc references are stale enough to update in this phase, provided the work stays within the roadmap's documentation surfaces. [VERIFIED: .planning/phases/05-documentation-refresh/05-CONTEXT.md]

### Deferred Ideas (OUT OF SCOPE)
- Broad user-facing renaming away from Kickstart terminology in runtime messages or help-provider identifiers belongs outside this docs-only phase unless a specific doc surface requires wording cleanup. [VERIFIED: .planning/phases/05-documentation-refresh/05-CONTEXT.md]
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| DOC-01 | Repository documentation describes the modular layout and where to customize the config | Make `README.md` the primary architecture guide, add a small layout map rooted in `init.lua -> lua/story/bootstrap.lua -> lua/core/* + lua/plugins/* + lua/custom/plugins/*`, and update help/inline guidance that still points users back to a monolithic `init.lua`. [VERIFIED: README.md] [VERIFIED: init.lua] [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: lua/custom/plugins/init.lua] |
| DOC-02 | The repo no longer presents the single-file layout as the intended architecture for this fork | Remove or rewrite the README FAQ defending the single-file model, align `doc/kickstart.txt`, trim or replace stale onboarding prose in `init.lua`, and stop pointing readers to `init.lua` as the main customization surface. [VERIFIED: README.md] [VERIFIED: doc/kickstart.txt] [VERIFIED: init.lua] |
</phase_requirements>

## Summary

This phase is a documentation realignment pass, not a runtime refactor. The codebase already boots through `require('story.bootstrap').setup()` from a thin `init.lua`, loads always-on editor behavior from `lua/core/*`, loads shipped plugin specs from `lua/plugins/*`, and reserves `lua/custom/plugins/*` as the stable user extension path. The current docs lag that reality: `README.md` still brands the repo as `kickstart.nvim`, calls it "Single-file", tells readers to learn by reading `init.lua`, and includes a FAQ defending the monolithic layout; `doc/kickstart.txt` still teaches the old identity; `init.lua` itself still contains the original Kickstart teaching banner; and `lua/custom/plugins/init.lua` still points readers to the old README framing. [VERIFIED: README.md] [VERIFIED: doc/kickstart.txt] [VERIFIED: init.lua] [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: lua/custom/plugins/init.lua]

Because this repo has no dedicated test runner, planning should treat verification as doc-surface checks plus lightweight Neovim validation. The most important execution detail is that `doc/tags` is a generated artifact and must be regenerated if `doc/kickstart.txt` changes; Neovim's help system documents `:helptags {dir}` as the standard way to rebuild sorted help tags and silently overwrite the existing tags file. [VERIFIED: doc/tags] [CITED: /opt/homebrew/Cellar/neovim/0.12.1/share/nvim/runtime/doc/helphelp.txt]

**Primary recommendation:** Update `README.md` first around the actual runtime ownership boundaries, then refresh `doc/kickstart.txt`, the large `init.lua` onboarding comment, and the `lua/custom/plugins/init.lua` pointer so every user-facing guidance surface teaches the same modular story and no surface still recommends the single-file architecture as the intended path. [VERIFIED: .planning/ROADMAP.md] [VERIFIED: README.md] [VERIFIED: doc/kickstart.txt] [VERIFIED: init.lua] [VERIFIED: lua/custom/plugins/init.lua]

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| `README.md` + Markdown docs | Repo-local surface; no external package version [VERIFIED: README.md] | Primary onboarding, install, and customization guide | This is already the repo's main user-facing guide and contains the stale single-file framing that Phase 5 must replace. [VERIFIED: README.md] [VERIFIED: .planning/ROADMAP.md] |
| Neovim help docs (`doc/*.txt` + `doc/tags`) | Repo-local help surface; local validator is `NVIM v0.12.1` [VERIFIED: doc/kickstart.txt] [VERIFIED: doc/tags] [VERIFIED: local command `nvim --version`] | In-editor help and searchable tags for shipped documentation | The repo already ships `doc/kickstart.txt` and `doc/tags`, so help-doc alignment is part of the existing documentation contract rather than an optional extra. [VERIFIED: doc/kickstart.txt] [VERIFIED: doc/tags] [VERIFIED: .planning/PROJECT.md] |
| Runtime code as documentation source of truth | Current repo structure under `init.lua`, `lua/story`, `lua/core`, `lua/plugins`, `lua/custom` [VERIFIED: init.lua] [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: local file listing `find lua -maxdepth 2 -type f`] | Canonical architecture that docs must describe | The planner should derive all wording from the code that already exists instead of preserving historical README language. [VERIFIED: .planning/phases/05-documentation-refresh/05-CONTEXT.md] [VERIFIED: init.lua] [VERIFIED: lua/story/bootstrap.lua] |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| `:helptags` | Official Neovim command; local runtime `0.12.1` [CITED: /opt/homebrew/Cellar/neovim/0.12.1/share/nvim/runtime/doc/helphelp.txt] [VERIFIED: local command `nvim --version`] | Regenerate `doc/tags` after editing help docs | Use whenever `doc/kickstart.txt` changes so tag lookup stays accurate. [VERIFIED: doc/kickstart.txt] [VERIFIED: doc/tags] [CITED: /opt/homebrew/Cellar/neovim/0.12.1/share/nvim/runtime/doc/helphelp.txt] |
| `:checkhealth kickstart` | Existing repo health provider [VERIFIED: lua/kickstart/health.lua] [VERIFIED: local command `nvim --headless '+checkhealth kickstart' +qall`] | Sanity-check that docs still point users at a live troubleshooting surface | Use as a smoke check after touching inline guidance that references health or install troubleshooting. [VERIFIED: README.md] [VERIFIED: init.lua] [VERIFIED: lua/kickstart/health.lua] |
| Repo grep checks | Available through checked-in files and local shell tools [VERIFIED: local command `rg -n \"single-file|single file|Kickstart|kickstart|lua/plugins|lua/core|lua/custom|custom.plugins|story.bootstrap|helptags|doc/tags\" README.md doc lua init.lua`] | Fast detection of stale phrases and missed doc surfaces | Use before and after edits to keep the phase scoped to real stale strings instead of broad prose churn. [VERIFIED: README.md] [VERIFIED: doc/kickstart.txt] [VERIFIED: init.lua] [VERIFIED: lua/custom/plugins/init.lua] |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Refreshing all active doc surfaces (`README.md`, help doc, inline comments) | README-only refresh | README-only work would miss success criterion 3 because `doc/kickstart.txt`, `init.lua`, and `lua/custom/plugins/init.lua` still contain stale guidance. [VERIFIED: .planning/ROADMAP.md] [VERIFIED: doc/kickstart.txt] [VERIFIED: init.lua] [VERIFIED: lua/custom/plugins/init.lua] |
| Describing `lua/kickstart/plugins/*` as legacy/example-only | Treating legacy modules as equal to `lua/custom/plugins/*` in docs | That would contradict the Phase 4 decision that `custom.plugins` is the stable user extension path and `kickstart.plugins.*` is compatibility/example-only. [VERIFIED: .planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md] [VERIFIED: lua/story/bootstrap.lua] |
| Regenerating `doc/tags` after help-doc edits | Leaving the existing tags file untouched | Untouched tags risk a mismatched help index because Neovim documents `:helptags` as the generator for `doc/tags` and the current repo already tracks that file. [VERIFIED: doc/tags] [CITED: /opt/homebrew/Cellar/neovim/0.12.1/share/nvim/runtime/doc/helphelp.txt] |

**Version verification / currency checks:**
```bash
nvim --version | head -1
nvim --headless '+checkhealth kickstart' +qall
nvim --headless -u NONE -i NONE '+helptags doc' +qall
```

## Architecture Patterns

### Recommended Project Structure
```text
README.md                  # Primary onboarding and architecture guide
doc/
├── kickstart.txt          # In-editor help doc; keep wording aligned with README
└── tags                   # Generated help-tag index; regenerate if kickstart.txt changes
init.lua                   # Thin entrypoint; inline banner should not teach the old model
lua/
├── story/bootstrap.lua    # Explains real startup orchestration path
├── core/                  # Always-on editor behavior
├── plugins/               # Shipped plugin behavior by concern
├── custom/plugins/        # Stable fork-local extension path
└── kickstart/plugins/     # Legacy/example optional modules
```

### Pattern 1: Architecture-First README
**What:** Make `README.md` teach the current startup flow and ownership boundaries before install details or FAQs. [VERIFIED: README.md] [VERIFIED: init.lua] [VERIFIED: lua/story/bootstrap.lua]
**When to use:** Plan `05-01`, because `README.md` is the highest-traffic doc surface and currently contains the most outdated framing. [VERIFIED: .planning/ROADMAP.md] [VERIFIED: README.md]
**Example:**
```markdown
## Layout

- `init.lua`: thin entrypoint for early globals and bootstrap handoff
- `lua/story/bootstrap.lua`: ordered startup orchestration
- `lua/core/`: always-on editor behavior such as options, keymaps, autocmds, diagnostics
- `lua/plugins/`: shipped plugin behavior grouped by concern
- `lua/custom/plugins/`: your fork-local plugin additions and overrides
- `lua/kickstart/plugins/`: legacy/example opt-in modules kept for compatibility
```

### Pattern 2: Document Customization by Ownership, Not by History
**What:** Teach users where to customize based on who owns the code path now, not on what the original Kickstart repo used to recommend. [VERIFIED: .planning/phases/05-documentation-refresh/05-CONTEXT.md] [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: lua/custom/plugins/init.lua]
**When to use:** In the README customization section and any help-doc pointers. [VERIFIED: README.md] [VERIFIED: doc/kickstart.txt]
**Example:**
```markdown
### Where to customize

- Change always-on editor behavior in `lua/core/`
- Adjust shipped plugin behavior in `lua/plugins/`
- Add fork-local plugins in `lua/custom/plugins/`
- Treat `lua/kickstart/plugins/` as compatibility/examples, not the main active path
```

### Pattern 3: Keep Compatibility Terminology Narrow
**What:** Preserve existing runtime compatibility names only where they are live interfaces, while still describing the repo itself as modular. [VERIFIED: .planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md] [VERIFIED: lua/kickstart/health.lua] [VERIFIED: doc/kickstart.txt]
**When to use:** In help docs and inline comments that must mention `kickstart` names which still exist in module paths or health checks. [VERIFIED: lua/kickstart/health.lua] [VERIFIED: lua/story/bootstrap.lua]
**Example:**
```text
The repo now uses a modular layout. Legacy `kickstart` names remain in some
compatibility surfaces such as help tags and optional example modules.
```

### Anti-Patterns to Avoid
- **README-only planning:** This phase explicitly includes remaining help and inline guidance surfaces. [VERIFIED: .planning/ROADMAP.md]
- **Rewriting install guidance that is still accurate:** Phase scope allows existing installation/dependency guidance to remain if it does not depend on the old single-file model. [VERIFIED: .planning/phases/05-documentation-refresh/05-CONTEXT.md]
- **Broad product rebrand:** Do not rename live runtime identifiers, health-provider names, or compatibility module paths unless a specific doc surface cannot be made accurate without it. [VERIFIED: .planning/phases/05-documentation-refresh/05-CONTEXT.md] [VERIFIED: .planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md]
- **Teaching `init.lua` as the main customization surface:** `init.lua` is now a thin entrypoint and should be described that way. [VERIFIED: init.lua] [VERIFIED: lua/story/bootstrap.lua]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Architecture explanation | New conceptual model disconnected from the code | A file-tree and startup-flow explanation derived from the current repo layout | The code already provides the modular boundaries; inventing a different story would create another round of drift. [VERIFIED: init.lua] [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: local file listing `find lua -maxdepth 2 -type f`] |
| Help-tag maintenance | Manual edits to `doc/tags` | `:helptags doc` | Neovim generates and sorts help tags automatically and overwrites existing tag files. [VERIFIED: doc/tags] [CITED: /opt/homebrew/Cellar/neovim/0.12.1/share/nvim/runtime/doc/helphelp.txt] |
| Validation harness | A new test framework for a docs-only phase | Existing `rg` checks plus headless `nvim` smoke commands | The repo has no dedicated test framework today, and this phase only needs structural/doc verification plus help sanity checks. [VERIFIED: .planning/codebase/TESTING.md] [VERIFIED: local command `nvim --headless '+checkhealth kickstart' +qall`] |
| Legacy-path migration | Moving or renaming `lua/kickstart/plugins/*` in a docs phase | Document them as compatibility/example paths | Phase 4 explicitly kept those modules as legacy/example opt-ins while `custom.plugins` became the stable extension path. [VERIFIED: .planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md] [VERIFIED: lua/story/bootstrap.lua] |

**Key insight:** The planner should spend effort on consistency across the four active guidance surfaces, not on inventing new infrastructure or renaming runtime internals. [VERIFIED: README.md] [VERIFIED: doc/kickstart.txt] [VERIFIED: init.lua] [VERIFIED: lua/custom/plugins/init.lua]

## Common Pitfalls

### Pitfall 1: Leaving the Single-File FAQ Intact
**What goes wrong:** The README still explains why the config is intentionally single-file even after the repo has been modularized. [VERIFIED: README.md]
**Why it happens:** That FAQ is long, prominent, and easy to overlook while rewriting the introduction. [VERIFIED: README.md]
**How to avoid:** Replace the FAQ with a modular-layout section or a short "what changed" note that points readers to `lua/core/`, `lua/plugins/`, and `lua/custom/plugins/`. [VERIFIED: .planning/phases/05-documentation-refresh/05-CONTEXT.md] [VERIFIED: README.md]
**Warning signs:** `rg -n "single-file|single file" README.md` still returns matches after the README rewrite. [VERIFIED: local grep result over README.md]

### Pitfall 2: Forgetting Inline Guidance Outside README
**What goes wrong:** README is accurate, but `init.lua`, `doc/kickstart.txt`, or `lua/custom/plugins/init.lua` still teach the old workflow. [VERIFIED: doc/kickstart.txt] [VERIFIED: init.lua] [VERIFIED: lua/custom/plugins/init.lua]
**Why it happens:** Those files feel secondary compared with the README, but they are active user-facing entrypoints. [VERIFIED: init.lua] [VERIFIED: doc/kickstart.txt]
**How to avoid:** Plan the phase as two passes: README first, then a grep-driven stale-guidance sweep across help and inline comments. [VERIFIED: .planning/ROADMAP.md] [VERIFIED: local grep result over README.md/doc/lua/init.lua]
**Warning signs:** Grep still finds phrases like `single-file`, `Read through the init.lua`, or `See the kickstart.nvim README` in shipped user-facing files. [VERIFIED: README.md] [VERIFIED: init.lua] [VERIFIED: lua/custom/plugins/init.lua]

### Pitfall 3: Overshooting into Runtime Rebranding
**What goes wrong:** The phase starts renaming `kickstart` module paths, health identifiers, or help tags instead of just fixing stale documentation. [VERIFIED: .planning/phases/05-documentation-refresh/05-CONTEXT.md] [VERIFIED: lua/kickstart/health.lua] [VERIFIED: doc/tags]
**Why it happens:** The docs do contain stale Kickstart branding, but Phase 4 explicitly deferred broad runtime renaming. [VERIFIED: .planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md]
**How to avoid:** Keep the repo description modular and current while treating remaining `kickstart` identifiers as compatibility names unless the docs become inaccurate without a rename. [VERIFIED: .planning/phases/05-documentation-refresh/05-CONTEXT.md]
**Warning signs:** The diff begins changing help tags, module names, or `vim.health.start 'kickstart.nvim'`. [VERIFIED: doc/tags] [VERIFIED: lua/kickstart/health.lua]

### Pitfall 4: Changing Help Text Without Regenerating Tags
**What goes wrong:** `doc/kickstart.txt` changes, but `doc/tags` still reflects the old tag index. [VERIFIED: doc/kickstart.txt] [VERIFIED: doc/tags]
**Why it happens:** `doc/tags` is generated and easy to forget if the planner focuses only on prose files. [VERIFIED: doc/tags]
**How to avoid:** Treat `:helptags doc` as part of the phase-close verification whenever the help doc changes. [CITED: /opt/homebrew/Cellar/neovim/0.12.1/share/nvim/runtime/doc/helphelp.txt]
**Warning signs:** `git diff` shows help-doc content changed but `doc/tags` untouched. [VERIFIED: doc/kickstart.txt] [VERIFIED: doc/tags]

## Code Examples

Verified patterns from the current repo and official Neovim help:

### README Architecture Map
```markdown
## Architecture

`init.lua` only handles early globals and hands off to `require('story.bootstrap').setup()`.

- `lua/story/` owns startup orchestration
- `lua/core/` owns always-on editor behavior
- `lua/plugins/` owns shipped plugin behavior
- `lua/custom/plugins/` is the stable fork-local extension path
- `lua/kickstart/plugins/` remains for legacy/example opt-ins
```

### Help-Tag Regeneration
```bash
# Source: /opt/homebrew/Cellar/neovim/0.12.1/share/nvim/runtime/doc/helphelp.txt
nvim --headless -u NONE -i NONE '+helptags doc' +qall
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Teach the repo as a single-file Kickstart config centered on `init.lua` | Teach the repo as a modular fork with a thin `init.lua` and ownership split across `lua/story`, `lua/core`, `lua/plugins`, and `lua/custom` | Phases 1-4 completed on 2026-04-11 [VERIFIED: .planning/ROADMAP.md] [VERIFIED: .planning/STATE.md] | Documentation should explain current ownership boundaries instead of the historical monolith. [VERIFIED: init.lua] [VERIFIED: lua/story/bootstrap.lua] |
| Treat `kickstart.plugins.*` as the obvious extension surface | Treat `custom.plugins` as the stable extension path and `kickstart.plugins.*` as legacy/example-only | Phase 4 completed on 2026-04-11 [VERIFIED: .planning/ROADMAP.md] [VERIFIED: .planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md] | README and help docs should steer fork-local customization to `lua/custom/plugins/`. [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: lua/custom/plugins/init.lua] |

**Deprecated/outdated:**
- The README introduction that calls the repo "Single-file" is outdated for this fork. [VERIFIED: README.md]
- The README FAQ defending the single-file architecture is outdated for this fork. [VERIFIED: README.md]
- The `init.lua` banner telling readers to keep learning by reading the rest of the monolithic file is outdated for this fork. [VERIFIED: init.lua]

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | `grep -R` is a viable fallback if `rg` is unavailable on the execution machine. [ASSUMED] | Environment Availability | Low; planner may need to swap one structural audit command if `rg` is missing. |
| A2 | Keeping the existing `kickstart.nvim` help topic stable is the safer default unless the user explicitly wants broader rebranding. [ASSUMED] | Open Questions | Medium; planner could under-scope help-tag changes if the user expects a renamed help topic in this phase. |

## Open Questions

1. **Should Phase 5 change the help tag identity or keep `kickstart.nvim` as the help topic?**
   - What we know: The phase explicitly defers broad runtime rebranding, `doc/kickstart.txt` currently publishes `*kickstart.nvim*`, and `lua/kickstart/health.lua` still starts health output as `kickstart.nvim`. [VERIFIED: .planning/phases/05-documentation-refresh/05-CONTEXT.md] [VERIFIED: doc/kickstart.txt] [VERIFIED: lua/kickstart/health.lua]
   - What's unclear: Whether the planner should keep the help topic stable for compatibility and only modernize the prose, or also introduce a new alias tag. [VERIFIED: doc/tags] [ASSUMED]
   - Recommendation: Default to keeping the existing help tag/topic stable in this docs phase and limit changes to prose unless the user explicitly wants a broader rebrand. [VERIFIED: .planning/phases/05-documentation-refresh/05-CONTEXT.md] [ASSUMED]

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| Neovim | Help-tag regeneration and headless doc validation | ✓ [VERIFIED: local command `nvim --version`] | `NVIM v0.12.1` [VERIFIED: local command `nvim --version`] | — |
| `rg` | Fast stale-string audits across docs and inline comments | ✓ [VERIFIED: local grep command succeeded] | Version not captured in this session [VERIFIED: local grep command succeeded] | `grep -R` if needed [ASSUMED] |
| Git | Normal repo workflow and diff review | ✓ [VERIFIED: local command `git --version`] | `git version 2.53.0` [VERIFIED: local command `git --version`] | — |

**Missing dependencies with no fallback:**
- None. [VERIFIED: local environment audit]

**Missing dependencies with fallback:**
- None. [VERIFIED: local environment audit]

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | None dedicated; use shell/grep plus headless `nvim` smoke checks. [VERIFIED: .planning/codebase/TESTING.md] |
| Config file | none — no repository test runner config detected. [VERIFIED: .planning/codebase/TESTING.md] |
| Quick run command | `sh -c "rg -n \"lua/core/|lua/plugins/|lua/custom/plugins/|story.bootstrap\" README.md && ! rg -n \"single-file|single file\" README.md doc/kickstart.txt init.lua lua/custom/plugins/init.lua"` [VERIFIED: current stale strings found with local grep] |
| Full suite command | `sh -c "rg -n \"lua/core/|lua/plugins/|lua/custom/plugins/|story.bootstrap\" README.md && nvim --headless -u NONE -i NONE '+helptags doc' +qall && nvim --headless '+checkhealth kickstart' +qall"` [VERIFIED: local command `nvim --headless '+checkhealth kickstart' +qall`] [CITED: /opt/homebrew/Cellar/neovim/0.12.1/share/nvim/runtime/doc/helphelp.txt] |

### Phase Requirements → Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| DOC-01 | Docs explain modular structure and customization points | smoke + structural | `sh -c "rg -n \"lua/core/|lua/plugins/|lua/custom/plugins/|story.bootstrap\" README.md doc/kickstart.txt init.lua lua/custom/plugins/init.lua"` [VERIFIED: relevant files exist] | ✅ [VERIFIED: README.md] |
| DOC-02 | Repo no longer teaches the single-file model as intended architecture | structural | `sh -c "! rg -n \"single-file|single file\" README.md doc/kickstart.txt init.lua lua/custom/plugins/init.lua"` [VERIFIED: current stale phrases exist and are searchable] | ✅ [VERIFIED: README.md] |

### Sampling Rate
- **Per task commit:** Run the grep-based structural checks. [VERIFIED: local grep command succeeded]
- **Per wave merge:** If `doc/kickstart.txt` changes, run `nvim --headless -u NONE -i NONE '+helptags doc' +qall`. [CITED: /opt/homebrew/Cellar/neovim/0.12.1/share/nvim/runtime/doc/helphelp.txt]
- **Phase gate:** Re-run the full suite command and inspect the resulting diff for any accidental runtime renames. [VERIFIED: doc/tags] [VERIFIED: lua/kickstart/health.lua]

### Wave 0 Gaps
- None — the phase can rely on existing shell and headless Neovim validation without adding a test framework. [VERIFIED: .planning/codebase/TESTING.md] [VERIFIED: local environment audit]

## Security Domain

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|-----------------|
| V2 Authentication | no [VERIFIED: docs-only phase scope] | No authentication changes are in scope. [VERIFIED: .planning/ROADMAP.md] |
| V3 Session Management | no [VERIFIED: docs-only phase scope] | No session behavior changes are in scope. [VERIFIED: .planning/ROADMAP.md] |
| V4 Access Control | no [VERIFIED: docs-only phase scope] | No access-control behavior changes are in scope. [VERIFIED: .planning/ROADMAP.md] |
| V5 Input Validation | no [VERIFIED: docs-only phase scope] | The phase edits documentation only; runtime validation remains existing `:checkhealth` and help-tag generation. [VERIFIED: .planning/ROADMAP.md] [VERIFIED: lua/kickstart/health.lua] [CITED: /opt/homebrew/Cellar/neovim/0.12.1/share/nvim/runtime/doc/helphelp.txt] |
| V6 Cryptography | no [VERIFIED: docs-only phase scope] | No cryptography changes are in scope. [VERIFIED: .planning/ROADMAP.md] |

### Known Threat Patterns for documentation-alignment work

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Users are instructed to edit legacy or compatibility paths instead of the active modular paths | Tampering | Keep all customization guidance anchored to `lua/core/`, `lua/plugins/`, and `lua/custom/plugins/`, and label `lua/kickstart/plugins/` as legacy/example-only. [VERIFIED: .planning/phases/05-documentation-refresh/05-CONTEXT.md] [VERIFIED: lua/story/bootstrap.lua] |
| Help docs change without a matching tag refresh, causing stale help navigation | Denial of Service | Regenerate `doc/tags` with `:helptags doc` whenever `doc/kickstart.txt` changes. [VERIFIED: doc/tags] [CITED: /opt/homebrew/Cellar/neovim/0.12.1/share/nvim/runtime/doc/helphelp.txt] |

## Sources

### Primary (HIGH confidence)
- `.planning/phases/05-documentation-refresh/05-CONTEXT.md` - locked decisions, scope, canonical refs, and deferred rebrand boundary. [VERIFIED: local file read]
- `.planning/REQUIREMENTS.md` - `DOC-01` and `DOC-02` requirement wording. [VERIFIED: local file read]
- `.planning/ROADMAP.md` - Phase 5 success criteria and two-plan breakdown. [VERIFIED: local file read]
- `.planning/STATE.md` - current project position and completion of Phases 1-4. [VERIFIED: local file read]
- `README.md` - current stale single-file framing and install/customization guidance. [VERIFIED: local file read]
- `doc/kickstart.txt` and `doc/tags` - current in-editor help surface and shipped tags. [VERIFIED: local file read]
- `init.lua`, `lua/story/bootstrap.lua`, `lua/custom/plugins/init.lua`, `lua/kickstart/health.lua` - runtime architecture and remaining inline guidance. [VERIFIED: local file read]
- `.planning/codebase/TESTING.md` - existing validation posture and lack of dedicated test runner. [VERIFIED: local file read]
- Local commands: `nvim --version`, `nvim --headless '+checkhealth kickstart' +qall`, repo grep audits, and file listings. [VERIFIED: local command output]

### Secondary (MEDIUM confidence)
- `/opt/homebrew/Cellar/neovim/0.12.1/share/nvim/runtime/doc/helphelp.txt` - official local Neovim documentation for `:helptags`. [CITED: /opt/homebrew/Cellar/neovim/0.12.1/share/nvim/runtime/doc/helphelp.txt]
- `/opt/homebrew/Cellar/neovim/0.12.1/share/nvim/runtime/doc/starting.txt` - official local Neovim documentation for `$NVIM_APPNAME`. [CITED: /opt/homebrew/Cellar/neovim/0.12.1/share/nvim/runtime/doc/starting.txt]

### Tertiary (LOW confidence)
- None. [VERIFIED: research session evidence]

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - the phase concerns repo-local documentation surfaces and local Neovim tooling that were verified directly. [VERIFIED: local file reads] [VERIFIED: local commands]
- Architecture: HIGH - the runtime ownership boundaries are explicit in `init.lua`, `lua/story/bootstrap.lua`, and the `lua/` tree. [VERIFIED: init.lua] [VERIFIED: lua/story/bootstrap.lua] [VERIFIED: local file listing]
- Pitfalls: HIGH - each pitfall is grounded in current stale strings or explicit phase-scope decisions already recorded in project docs. [VERIFIED: README.md] [VERIFIED: doc/kickstart.txt] [VERIFIED: .planning/phases/05-documentation-refresh/05-CONTEXT.md]

**Research date:** 2026-04-11
**Valid until:** 2026-05-11
