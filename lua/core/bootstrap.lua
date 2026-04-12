local M = {}

local function ensure_config_root_on_rtp(config_root)
  vim.opt.rtp:prepend(config_root)
end

function M.setup()
  -- Core editor behavior
  local source = debug.getinfo(1, 'S').source:sub(2)
  source = vim.uv.fs_realpath(source) or source
  local config_root = vim.fs.dirname(vim.fs.dirname(vim.fs.dirname(source)))
  ensure_config_root_on_rtp(config_root)

  require('core.options').setup()
  require('core.diagnostics').setup()
  require('core.keymaps').setup()
  require('core.autocmds').setup()

  -- Runtime helpers
  -- Sync clipboard between OS and Neovim after startup-sensitive work.
  vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

  -- Plugin manager bootstrap
  -- [[ Install `lazy.nvim` plugin manager ]]
  --    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
  require('core.bootstrap.lazy').setup()

  -- [[ Configure and install plugins ]]
  --
  --  To check the current status of your plugins, run
  --    :Lazy
  --
  --  You can press `?` in this menu for help. Use `:q` to close the window
  --
  --  To update plugins you can run
  --    :Lazy update
  --
  require('lazy').setup({
    spec = {
      { import = 'plugins' },
      { import = 'custom.plugins' },
    },

    -- NOTE: `lua/custom/plugins/*.lua` is the stable user extension path for adding your own plugins,
    -- configuration, and overrides without changing the shipped `lua/plugins` source of truth.
    --
    -- NOTE: `lua/kickstart/plugins/*.lua` remains a legacy/example opt-in surface from the Kickstart repo.
    --
    -- require 'kickstart.plugins.debug',
    -- require 'kickstart.plugins.indent_line',
    -- require 'kickstart.plugins.lint',
    -- require 'kickstart.plugins.autopairs',
    -- require 'kickstart.plugins.neo-tree',
    -- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommended keymaps

    -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
    -- Or use telescope!
    -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
    -- you can continue same window with `<space>sr` which resumes last telescope search
  }, { ---@diagnostic disable-line: missing-fields
    ui = {
      -- If you are using a Nerd Font: set icons to an empty table which will use the
      -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
      icons = vim.g.have_nerd_font and {} or {
        cmd = '⌘',
        config = '🛠',
        event = '📅',
        ft = '📂',
        init = '⚙',
        keys = '🗝',
        plugin = '🔌',
        runtime = '💻',
        require = '🌙',
        source = '📄',
        start = '🚀',
        task = '📌',
        lazy = '💤 ',
      },
    },
  })

  ensure_config_root_on_rtp(config_root)

  -- The line beneath this is called `modeline`. See `:help modeline`
  -- vim: ts=2 sts=2 sw=2 et
end

return M
