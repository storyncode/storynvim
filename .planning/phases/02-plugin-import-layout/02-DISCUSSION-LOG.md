# Phase 2 Discussion Log

**Date:** 2026-04-11
**Phase:** 2 - Plugin Import Layout
**Outcome:** Recommended defaults accepted for all identified gray areas

## Questions And Answers

### Plugin Namespace Shape
- **Question:** Should the active shipped plugin specs move into a new primary namespace, or should the repo continue using the existing `kickstart/custom` plugin namespaces as the main structure?
- **Options presented:**
  - Create a primary `lua/plugins/` namespace for active shipped specs, while leaving `kickstart/custom` as supporting namespaces.
  - Reuse `lua/kickstart/plugins/` as the main shipped namespace.
  - Keep a mixed namespace split across `lua/kickstart/plugins/`, `lua/custom/plugins/`, and inline specs.
- **Decision:** Accepted recommendation to create a new primary `lua/plugins/` namespace for active shipped specs and leave `kickstart/custom` as supporting/example namespaces.

### Grouping Strategy
- **Question:** How should the new plugin spec modules be grouped?
- **Options presented:**
  - Group by concern, such as editor, LSP, Telescope, UI, and coding.
  - Group by load timing, such as startup vs lazy-loaded.
  - Group by ownership, such as base vs optional vs custom.
- **Decision:** Accepted recommendation to group by concern.

### Optional Module Handling
- **Question:** Should existing optional/example plugin modules be migrated into the new primary namespace as part of Phase 2?
- **Options presented:**
  - Keep existing optional/example modules where they are unless compatibility shims are needed.
  - Migrate all optional/example modules into the new `lua/plugins/` namespace immediately.
  - Leave the phase hybrid with no clear handling rule.
- **Decision:** Accepted recommendation to keep existing optional/example modules in place unless small compatibility shims are needed.

### Import Style Strictness
- **Question:** Should Phase 2 end with imports as the canonical source of truth, or leave a temporary hybrid of imports plus inline plugin specs?
- **Options presented:**
  - Make imports the canonical source of truth and remove the old inline plugin table by the end of the phase.
  - Allow a temporary hybrid structure for this phase.
  - Leave strictness undecided until implementation.
- **Decision:** Accepted recommendation to make imports canonical and remove the old inline table by the end of Phase 2.

## Notes

- User response: "recommendations are fine"
- No out-of-scope requests or deferred ideas surfaced during discussion.

---

*Phase: 02-plugin-import-layout*
*Logged: 2026-04-11*
