# Codebase Structure

**Analysis Date:** 2026-04-11

## Directory Layout

```text
[project-root]/
├── init.lua                 # Primary Neovim startup file and active configuration
├── lua/
│   ├── kickstart/           # Built-in modules shipped with the starter config
│   │   ├── health.lua       # :checkhealth provider
│   │   └── plugins/         # Optional example LazySpec modules
│   └── custom/
│       └── plugins/         # User-owned extension namespace for custom LazySpec modules
├── doc/
│   ├── kickstart.txt        # Vim help documentation
│   └── tags                 # Help tag index
├── .github/                 # Repository metadata and workflow configuration
├── .planning/codebase/      # Generated codebase mapping documents
├── README.md                # Installation and usage guide
├── LICENSE.md               # License text
└── .stylua.toml             # Lua formatter configuration
```

## Directory Purposes

**`lua/kickstart/`:**
- Purpose: Hold internal modules that belong to the shipped Kickstart starter.
- Contains: `health.lua` and optional plugin-spec modules under `lua/kickstart/plugins/`.
- Key files: `lua/kickstart/health.lua`, `lua/kickstart/plugins/debug.lua`, `lua/kickstart/plugins/lint.lua`

**`lua/kickstart/plugins/`:**
- Purpose: Store example or optional plugin modules that can be enabled from `init.lua`.
- Contains: One plugin spec per file, each returning a `LazySpec`.
- Key files: `lua/kickstart/plugins/autopairs.lua`, `lua/kickstart/plugins/gitsigns.lua`, `lua/kickstart/plugins/indent_line.lua`, `lua/kickstart/plugins/lint.lua`, `lua/kickstart/plugins/neo-tree.lua`, `lua/kickstart/plugins/debug.lua`

**`lua/custom/plugins/`:**
- Purpose: Reserve a safe namespace for end-user additions.
- Contains: Custom plugin specs; currently only an empty placeholder module.
- Key files: `lua/custom/plugins/init.lua`

**`doc/`:**
- Purpose: Publish editor help content.
- Contains: Help text and generated help tags.
- Key files: `doc/kickstart.txt`, `doc/tags`

**`.github/`:**
- Purpose: Host GitHub-specific repository assets.
- Contains: Issue templates and workflow metadata.
- Key files: `.github/pull_request_template.md`, `.github/workflows/`

**`.planning/codebase/`:**
- Purpose: Store generated architecture and quality mapping docs for automation workflows.
- Contains: Planning markdown documents.
- Key files: `.planning/codebase/ARCHITECTURE.md`, `.planning/codebase/STRUCTURE.md`

## Key File Locations

**Entry Points:**
- `init.lua`: The only active runtime startup file.
- `lua/kickstart/health.lua`: Health subsystem entry point.
- `doc/kickstart.txt`: Vim help entry point.

**Configuration:**
- `init.lua`: Core options, keymaps, autocommands, lazy bootstrap, and plugin declarations.
- `.stylua.toml`: Lua formatting settings.
- `README.md`: Installation constraints and extension instructions.

**Core Logic:**
- `init.lua`: All active core behavior lives here, including plugin setup and event wiring.
- `lua/kickstart/plugins/debug.lua`: Optional debug stack module.
- `lua/kickstart/plugins/lint.lua`: Optional linting module.
- `lua/kickstart/plugins/gitsigns.lua`: Optional git keymap extension module.

**Testing:**
- Not detected. There are no test directories, test files, or test runner configs in the repository root.

## Naming Conventions

**Files:**
- Root entrypoint uses Neovim’s required conventional name: `init.lua`.
- Lua modules use lowercase snake_case filenames: `health.lua`, `indent_line.lua`, `neo-tree.lua` is the one hyphenated exception matching plugin branding.
- Optional plugin modules are named after the plugin or capability they configure: `debug.lua`, `lint.lua`, `autopairs.lua`.

**Directories:**
- Lua module namespaces mirror `require(...)` paths: `lua/kickstart/plugins/` maps to `require 'kickstart.plugins.*'`, and `lua/custom/plugins/` maps to `require 'custom.plugins.*'` or `{ import = 'custom.plugins' }`.
- Documentation lives in the conventional Vim help directory `doc/`.

## Where to Add New Code

**New Feature:**
- Primary code: Add the plugin spec directly in `init.lua` if the feature should stay part of the single-file base configuration.
- Tests: Not applicable inside this repo structure; there is no existing test harness.

**New Optional Plugin Module:**
- Implementation: Add a new file under `lua/kickstart/plugins/` if it is an upstream-style example module intended to be toggled from `init.lua`.
- Activation: Reference it from `init.lua` using `require 'kickstart.plugins.NAME'`.

**New User-Specific Customization:**
- Implementation: Add a new file under `lua/custom/plugins/` or extend `lua/custom/plugins/init.lua`.
- Activation: Uncomment `{ import = 'custom.plugins' }` in `init.lua`.

**Utilities:**
- Shared helpers: Place them under `lua/kickstart/` only if they are reusable across multiple modules and are meant to ship with the base starter.
- Custom helpers: Place them under `lua/custom/` if they belong to local customization rather than the upstream starter behavior.

**Documentation Updates:**
- User-facing install and rationale docs: `README.md`
- In-editor help docs: `doc/kickstart.txt`

## Structural Rules To Follow

- Keep `init.lua` as the canonical startup file; nothing else currently replaces or wraps it.
- Return `LazySpec` tables from plugin modules under `lua/kickstart/plugins/` and `lua/custom/plugins/`.
- Name new Lua files so their path matches the intended `require(...)` namespace.
- Put Vim help content only under `doc/`; keep runtime Lua code under `lua/`.
- Do not create `src/`, `lib/`, or application-style layers unless you intentionally move away from the current Kickstart single-file architecture.

## Special Directories

**`doc/`:**
- Purpose: Vim help distribution content.
- Generated: Partially. `doc/tags` is generated; `doc/kickstart.txt` is authored.
- Committed: Yes.

**`.planning/codebase/`:**
- Purpose: Generated planning/reference documents for GSD workflows.
- Generated: Yes.
- Committed: Yes, intended for workflow consumption.

**`.github/workflows/`:**
- Purpose: CI and repository automation metadata.
- Generated: No.
- Committed: Yes.

## Placement Guidance By Existing Pattern

**If the code is always-on editor behavior:**
- Put it in `init.lua` near the matching section, such as options, keymaps, autocommands, or plugin registration.

**If the code is a self-contained optional plugin example:**
- Put it in a new `lua/kickstart/plugins/<name>.lua` file and enable it from `init.lua`.

**If the code is fork-local and should avoid merge conflicts with upstream Kickstart updates:**
- Put it in `lua/custom/plugins/` and use the `custom.plugins` import path from `init.lua`.

**If the code is explanatory or onboarding material:**
- Put repo-level prose in `README.md`.
- Put in-editor help prose in `doc/kickstart.txt`.

---

*Structure analysis: 2026-04-11*
