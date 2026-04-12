--[[

=====================================================================
====================== START HERE IF YOU'RE CUSTOMIZING ======================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||     STORYNVIM      ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

This file is intentionally small.

  `init.lua` only handles early globals and then hands off startup to:
    `require('core.bootstrap').setup()`

Where to change things:

  - `lua/core/` for always-on editor behavior like options, keymaps,
    diagnostics, and autocmds
  - `lua/plugins/` for shipped plugin specs and plugin configuration
  - `lua/custom/plugins/` for your own plugins, overrides, and fork-local changes

Compatibility note:

  - `lua/kickstart/plugins/` still exists as a compatibility/example namespace,
    but it is not the preferred path for new customization in this fork.

Useful references:

  - `README.md` for the current architecture and customization guide
  - `:help lua-guide` for Neovim's Lua integration docs
  - `:Tutor` if you are still learning core Neovim motions and editing

Edit the module that matches the change you want instead of treating this file
as the main configuration surface.
--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false

local init_source = debug.getinfo(1, 'S').source:sub(2)
local config_root = vim.fs.dirname(vim.uv.fs_realpath(init_source) or init_source)
vim.opt.rtp:prepend(config_root)

require('core.bootstrap').setup()
