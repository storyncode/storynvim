# Phase 5: Documentation Refresh - Context

**Gathered:** 2026-04-11
**Status:** Ready for planning

<domain>
## Phase Boundary

Rewrite repository guidance so it accurately teaches the modular Neovim layout that now exists. This phase covers the main onboarding and help surfaces that still describe the repo as a single-file Kickstart config, plus clear guidance on where to customize plugins, core editor behavior, and optional modules. It does not introduce new product features or rebrand the runtime architecture beyond what documentation needs to explain correctly.

</domain>

<decisions>
## Implementation Decisions

### Documentation Positioning
- **D-01:** The repo should now describe itself as a modular personal or forkable Neovim configuration, not as an intentionally single-file teaching config.
- **D-02:** Documentation should explain the current architecture in terms of the actual module layout (`init.lua`, `lua/story`, `lua/core`, `lua/plugins`, `lua/custom`) instead of preserving outdated historical framing.

### Customization Guidance
- **D-03:** `README.md` should clearly point users to `lua/plugins/` for shipped plugin behavior, `lua/core/` for always-on editor behavior, and `lua/custom/plugins/` for fork-local extension.
- **D-04:** Legacy `lua/kickstart/plugins/` modules should be documented as compatibility or example paths rather than the main active customization route.

### Scope And Tone
- **D-05:** The documentation refresh should stay structural and practical: explain what changed, where things live, and how to customize safely without turning the phase into a broader product rewrite.
- **D-06:** Existing installation and dependency guidance can stay where still accurate, but any text that depends on the old single-file model should be updated or removed.

### the agent's Discretion
- Exact README structure, section ordering, and how much historical context to retain, as long as the active architecture and customization paths become obvious.
- Whether to add a concise architecture map, migration notes, or file-tree examples if they improve clarity without bloating the docs.
- Which remaining inline or help-doc references are stale enough to update in this phase, provided the work stays within the roadmap's documentation surfaces.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Planning And Scope
- `.planning/PROJECT.md` — Project vision, constraints, and the requirement to replace outdated single-file documentation.
- `.planning/REQUIREMENTS.md` — Phase-linked documentation requirements, especially `DOC-01` and `DOC-02`.
- `.planning/ROADMAP.md` — Phase 5 goal, success criteria, and the two-plan breakdown for README plus remaining docs.
- `.planning/STATE.md` — Current phase position and recent decisions that the docs need to reflect.
- `.planning/phases/04-compatibility-and-cleanup/04-CONTEXT.md` — Prior decision that `custom.plugins` is the stable extension path and `kickstart.plugins.*` is legacy/example-only.

### Active Documentation Surfaces
- `README.md` — Primary onboarding and customization guide that still presents the repo as single-file Kickstart.
- `doc/kickstart.txt` — Shipped help doc that still describes the old project identity and needs alignment review.
- `doc/tags` — Help tags file that may need regeneration or validation if help docs change.

### Active Runtime Structure
- `init.lua` — Thin entrypoint whose minimal role should be explained correctly in docs.
- `lua/story/bootstrap.lua` — Startup orchestrator and compatibility guidance that anchors the runtime architecture story.
- `lua/core/options.lua` — Example of extracted always-on editor behavior the docs should point users to.
- `lua/core/keymaps.lua` — Example of extracted always-on keymap ownership.
- `lua/core/autocmds.lua` — Example of extracted always-on autocommand ownership.
- `lua/plugins/editor.lua` — Example shipped plugin concern module under the new layout.
- `lua/plugins/lsp.lua` — Example shipped plugin concern module users may customize.
- `lua/custom/plugins/init.lua` — Stable user-owned extension path that should be called out explicitly.
- `lua/kickstart/health.lua` — Existing user-facing help surface that still carries Kickstart naming and may constrain how broadly docs can claim rebranding.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `README.md`: Already contains installation, dependency, and FAQ material that can be kept and rewritten rather than replaced wholesale.
- `doc/kickstart.txt`: Existing help-doc entrypoint that can be refreshed to match the modular architecture.
- `lua/core/*.lua`: Concrete examples of where always-on editor behavior now lives.
- `lua/plugins/*.lua`: Concrete examples of the concern-based plugin layout the docs need to teach.
- `lua/custom/plugins/init.lua`: Existing extension hook that supports a clear customization story without changing runtime behavior.

### Established Patterns
- Startup now flows from `init.lua` into `require('story.bootstrap').setup()`, so docs should present `init.lua` as a thin entrypoint rather than the main customization surface.
- Shipped plugin specs live under `lua/plugins/`, while user-owned additions live under `lua/custom/plugins/`.
- The codebase favors readable, instructional Lua and conservative structural refactors rather than broad redesign.
- Compatibility work intentionally kept some Kickstart-facing names in code, so docs should distinguish runtime compatibility surfaces from the preferred customization paths.

### Integration Points
- README changes need to align with the actual module layout already implemented in `init.lua`, `lua/story/`, `lua/core/`, and `lua/plugins/`.
- Help-doc updates must stay consistent with the compatibility story around `lua/kickstart/health.lua` and legacy/example module paths.
- Any doc examples about adding plugins or tweaking editor behavior should point to the stable active paths, especially `lua/custom/plugins/` and `lua/core/`.

</code_context>

<specifics>
## Specific Ideas

- A short architecture map or file tree would likely clarify the new layout faster than prose alone.
- The FAQ entry defending the intentionally single-file model should be rewritten or removed rather than softened.
- Users should be shown the difference between editing shipped plugin modules and adding private fork-local plugins under `lua/custom/plugins/`.

</specifics>

<deferred>
## Deferred Ideas

- Broad user-facing renaming away from Kickstart terminology in runtime messages or help-provider identifiers belongs outside this docs-only phase unless a specific doc surface requires wording cleanup.

</deferred>

---

*Phase: 05-documentation-refresh*
*Context gathered: 2026-04-11*
