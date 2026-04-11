# Phase 5: Documentation Refresh - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-04-11
**Phase:** 05-Documentation Refresh
**Areas discussed:** Documentation positioning, customization guidance, scope and tone

---

## Documentation Positioning

| Option | Description | Selected |
|--------|-------------|----------|
| Preserve single-file framing | Keep README centered on the historical Kickstart single-file identity and mention modular files only as optional follow-on changes. | |
| Present the modular layout as canonical | Rewrite onboarding so the current module structure is the primary explanation of how the repo works. | ✓ |
| Split the difference | Keep equal emphasis on both the single-file past and the modular present. | |

**User's choice:** `[auto] Present the modular layout as canonical`
**Notes:** Auto-selected because Phase 5 explicitly exists to refresh docs around the architecture already delivered in Phases 1-4.

---

## Customization Guidance

| Option | Description | Selected |
|--------|-------------|----------|
| Focus on shipped files only | Explain the internal modules but leave extension guidance implicit. | |
| Make active customization paths explicit | Call out `lua/plugins/`, `lua/core/`, and `lua/custom/plugins/` as the main places users should edit or extend. | ✓ |
| Preserve legacy paths as co-equal | Document `lua/kickstart/plugins/` and `lua/custom/plugins/` as equally primary extension routes. | |

**User's choice:** `[auto] Make active customization paths explicit`
**Notes:** Auto-selected to align documentation with the compatibility decision from Phase 4 that `custom.plugins` is the stable extension path and `kickstart.plugins.*` is legacy/example-only.

---

## Scope And Tone

| Option | Description | Selected |
|--------|-------------|----------|
| Full branding rewrite | Use the docs phase to broadly rename user-facing surfaces and runtime identity. | |
| Structural refresh only | Update stale guidance, teach the current layout, and leave broader branding changes out of scope. | ✓ |
| Minimal patching | Touch only the most incorrect lines and avoid broader explanatory improvements. | |

**User's choice:** `[auto] Structural refresh only`
**Notes:** Auto-selected because the roadmap scopes this phase to documentation accuracy, not a wider runtime or branding migration.

---

## the agent's Discretion

- Exact README structure and whether to add an architecture map or file-tree example.
- Which remaining doc/help surfaces need edits beyond `README.md`, provided they still materially assume the single-file model.

## Deferred Ideas

- Broader runtime or health-surface rebranding beyond what documentation wording requires.
