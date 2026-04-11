# Codebase Concerns

**Analysis Date:** 2026-04-11

## Tech Debt

**Monolithic configuration entrypoint:**
- Issue: Most configuration, plugin setup, keymaps, diagnostics, LSP wiring, formatter setup, completion, colorscheme, and Treesitter behavior live in one file.
- Files: `init.lua`
- Impact: Changes in unrelated areas share one edit surface, review scope stays large, merge conflicts are more likely, and regressions are harder to isolate because plugin interactions are configured inline instead of behind smaller modules.
- Fix approach: Split `init.lua` into focused modules under `lua/` for core options, keymaps, LSP, completion, formatting, and Treesitter. Keep `init.lua` as the composition root only.

**Unpinned plugin state in forks by default:**
- Issue: `.gitignore` excludes `lazy-lock.json` even though the README explicitly recommends tracking it in personal forks.
- Files: `.gitignore`, `README.md`
- Impact: Plugin versions drift between machines and over time. Reproducing startup failures or plugin regressions becomes difficult because installs are resolved dynamically.
- Fix approach: Remove `lazy-lock.json` from `.gitignore` in downstream forks and commit the generated lockfile. Keep the official template note in `README.md`, but make reproducible installs the default for actual users.

**Example plugins live outside the active setup path:**
- Issue: Additional plugin modules exist in `lua/kickstart/plugins/*.lua`, but the imports are commented out in `init.lua`.
- Files: `init.lua`, `lua/kickstart/plugins/debug.lua`, `lua/kickstart/plugins/gitsigns.lua`, `lua/kickstart/plugins/lint.lua`, `lua/kickstart/plugins/neo-tree.lua`, `lua/kickstart/plugins/indent_line.lua`, `lua/kickstart/plugins/autopairs.lua`
- Impact: Optional modules can drift unnoticed because they are versioned code without any verification path in default startup. Breakage only appears when a user decides to enable one.
- Fix approach: Add a lightweight CI matrix that validates both the default profile and an "optional plugins enabled" profile, or move examples into docs/snippets instead of shipping inactive code.

## Known Bugs

**No confirmed functional bugs in the default checked-in profile:**
- Symptoms: Not detected during static review of `init.lua` and helper modules.
- Files: `init.lua`, `lua/kickstart/health.lua`
- Trigger: Not applicable
- Workaround: Not applicable

**Health check under-reports installation problems:**
- Symptoms: `:checkhealth` can report a mostly healthy setup even when documented prerequisites such as `fd`, clipboard helpers, a C toolchain, or `tree-sitter` CLI are missing.
- Files: `lua/kickstart/health.lua`, `README.md`
- Trigger: Running the default health check on systems missing dependencies listed in the installation guide.
- Workaround: Cross-check `README.md` manually instead of relying on `:checkhealth` output alone.

## Security Considerations

**`pull_request_target` workflow runs against untrusted PR content:**
- Risk: The formatting workflow uses `pull_request_target`, checks out the contributor's head commit, and passes `${{ secrets.GITHUB_TOKEN }}` into the action. That combination expands the blast radius for supply-chain or workflow abuse compared with `pull_request`.
- Files: `.github/workflows/stylua.yml`
- Current mitigation: The job only runs in the upstream repository via `if: github.repository == 'nvim-lua/kickstart.nvim'`.
- Recommendations: Prefer `pull_request` for formatting-only validation, avoid exposing secrets to jobs that evaluate fork content, and pin third-party actions by commit SHA rather than major tag.

**Runtime bootstrapping trusts live network state:**
- Risk: First startup clones `lazy.nvim`, then resolves and downloads plugin code at runtime. Treesitter parsers are also installed on demand for missing languages.
- Files: `init.lua`
- Current mitigation: `lazy.nvim` is cloned from the stable branch and plugin declarations use known upstream repositories.
- Recommendations: Commit `lazy-lock.json` in real forks, document offline-safe bootstrap expectations, and avoid automatic parser installation in latency-sensitive or restricted environments.

## Performance Bottlenecks

**Automatic Treesitter installation on `FileType`:**
- Problem: Opening a buffer for a language with an available but not-yet-installed parser triggers `require('nvim-treesitter').install(language):await(...)` during a `FileType` autocommand.
- Files: `init.lua`
- Cause: Parser installation work is initiated from the editor event path instead of an explicit maintenance command.
- Improvement path: Restrict installs to a fixed parser list, remove `:await(...)` from the file-open path, or require explicit `:TSInstall` / `:TSUpdate` maintenance.

**Automatic tool installation during startup:**
- Problem: Mason installs whatever is listed in `ensure_installed` during startup flow, and the headless validation run confirmed that plugin bootstrap immediately performs network activity.
- Files: `init.lua`
- Cause: Tool provisioning is coupled directly to editor initialization.
- Improvement path: Make installation opt-in for first-run setup, or gate provisioning behind an explicit bootstrap command so startup stays deterministic.

**Large single-file startup path:**
- Problem: `init.lua` is 972 lines and contains most initialization logic in one code path.
- Files: `init.lua`
- Cause: Teaching-oriented single-file design.
- Improvement path: Move setup into smaller modules and lazy-load only the features that need to be present at startup.

## Fragile Areas

**Default profile depends on current Neovim APIs:**
- Files: `init.lua`, `lua/kickstart/health.lua`
- Why fragile: The configuration uses Neovim 0.11+ APIs such as `vim.lsp.config`, `vim.lsp.enable`, and current Treesitter entrypoints. That is consistent with the README target, but it narrows compatibility and makes breakage likely if users run older packaged versions.
- Safe modification: Keep API usage aligned with the minimum supported version in `README.md`, and validate against both latest stable and nightly before changing bootstrap or LSP wiring.
- Test coverage: No automated startup smoke test is present in the repository.

**Optional lint/debug modules rely on external tools with no guard rails:**
- Files: `lua/kickstart/plugins/lint.lua`, `lua/kickstart/plugins/debug.lua`
- Why fragile: These modules assume linters, debuggers, and supporting binaries are installable and compatible once enabled. They are examples, but users enable them by uncommenting imports rather than through a guided setup.
- Safe modification: Keep external-tool assumptions documented near each module and add `pcall` or health assertions where failures would otherwise surface only after activation.
- Test coverage: No validation path exists for these modules because they are disabled in the default setup and there are no automated tests.

## Scaling Limits

**Plugin and parser growth increases startup complexity non-linearly:**
- Current capacity: The checked-in profile is small, with one main config file and a short plugin list.
- Limit: As more plugins are added inline to `init.lua`, startup ordering, keymap collisions, and cross-plugin assumptions become harder to reason about because there is no module boundary or test suite.
- Scaling path: Move to feature modules under `lua/`, add a committed lockfile, and add a headless startup check in CI before expanding the plugin surface.

## Dependencies at Risk

**Unpinned GitHub Action tags:**
- Risk: `actions/checkout@v6` and `JohnnyMorganz/stylua-action@v4` are pinned only by major version tag.
- Impact: Upstream action changes can alter CI behavior without any repository change.
- Migration plan: Pin actions by full commit SHA and update them intentionally.

**`nvim-treesitter` tracks `branch = 'main'`:**
- Risk: The config tracks the plugin's main branch rather than a more stable tag or lockfile-controlled revision.
- Impact: Breaking upstream changes can land without any code change in the repository when users bootstrap on a new day.
- Migration plan: Rely on a committed `lazy-lock.json` in real deployments and avoid treating branch tracking as the only stability mechanism.

## Missing Critical Features

**No automated verification of startup behavior:**
- Problem: There is no script or CI job that launches Neovim headlessly with this config and fails on bootstrap/runtime errors.
- Blocks: Safe refactors of `init.lua`, confident updates to plugin configuration, and early detection of regressions in optional modules.

**No automated test coverage for optional examples:**
- Problem: Example plugin modules are shipped as code but not exercised.
- Blocks: Safe maintenance of `lua/kickstart/plugins/*.lua` as dependencies evolve.

## Test Coverage Gaps

**Startup and bootstrap path:**
- What's not tested: Cloning `lazy.nvim`, initial plugin resolution, Mason setup, LSP enablement, and Treesitter attach/install behavior.
- Files: `init.lua`
- Risk: Breaking plugin API changes or startup ordering regressions can ship unnoticed.
- Priority: High

**Health check accuracy:**
- What's not tested: Whether `lua/kickstart/health.lua` stays aligned with the documented dependencies in `README.md`.
- Files: `lua/kickstart/health.lua`, `README.md`
- Risk: Users can receive incomplete installation diagnostics and lose time debugging missing prerequisites manually.
- Priority: Medium

**Optional plugin modules:**
- What's not tested: Debug, lint, Neo-tree, autopairs, indent guides, and extended gitsigns setup after users uncomment the imports.
- Files: `lua/kickstart/plugins/debug.lua`, `lua/kickstart/plugins/lint.lua`, `lua/kickstart/plugins/neo-tree.lua`, `lua/kickstart/plugins/autopairs.lua`, `lua/kickstart/plugins/indent_line.lua`, `lua/kickstart/plugins/gitsigns.lua`
- Risk: Example modules can silently rot between releases and fail only when end users opt in.
- Priority: Medium

---

*Concerns audit: 2026-04-11*
