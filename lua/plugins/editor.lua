local pop_root = vim.fs.normalize(vim.fn.expand '~/vaults/price-of-power')

local function prompt_input(prompt, default)
  local ok, value = pcall(vim.fn.input, { prompt = prompt, default = default or '', completion = 'file' })
  if not ok then return nil end

  value = vim.trim(value)
  if value == '' then return nil end

  return value
end

local function get_day_subdir_default(bufname)
  local normalized = vim.fs.normalize(bufname)
  local prefix = pop_root .. '/Days/'
  if not vim.startswith(normalized, prefix) then return '' end

  local relative = normalized:sub(#prefix + 1)
  local parent = vim.fs.dirname(relative)
  if parent == '.' then return '' end

  return parent
end

local function create_pop_day_note(bufnr)
  local obsidian = require 'obsidian'
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  local subdir = prompt_input('Day subdirectory under Days: ', get_day_subdir_default(bufname))
  if not subdir then return end

  local day_name = prompt_input('Day note name: ', 'Day ')
  if not day_name then return end

  obsidian.actions.new_from_template(('Days/%s/%s'):format(subdir, day_name), 'Day')
end

---@module 'lazy'
---@type LazySpec
return {
  { 'NMAC427/guess-indent.nvim', opts = {} },

  -- Alternatively, use `config = function() ... end` for full control over the configuration.
  -- If you prefer to call `setup` explicitly, use:
  --    {
  --        'lewis6991/gitsigns.nvim',
  --        config = function()
  --            require('gitsigns').setup({
  --                -- Your gitsigns configuration here
  --            })
  --        end,
  --    }
  --
  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`.
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    ---@module 'gitsigns'
    ---@type Gitsigns.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      signs = {
        add = { text = '+' }, ---@diagnostic disable-line: missing-fields
        change = { text = '~' }, ---@diagnostic disable-line: missing-fields
        delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
        topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
        changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
      },
    },
  },

  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `opts` key (recommended), the configuration runs
  -- after the plugin has been loaded as `require(MODULE).setup(opts)`.

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter',
    ---@module 'which-key'
    ---@type wk.Opts
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },

      -- Document existing key chains
      spec = {
        { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>o', group = '[O]bsidian' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } }, -- Enable gitsigns recommended keymaps first
        { 'gr', group = 'LSP Actions', mode = { 'n' } },
      },
    },
  },
  {
    'obsidian-nvim/obsidian.nvim',
    version = '*', -- use latest release, remove to use latest commit
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      legacy_commands = false, -- this will be removed in the next major release
      workspaces = {
        {
          name = 'personal',
          path = '~/vaults/personal',
          overrides = {
            templates = {
              customizations = {
                daily = {
                  notes_subdir = 'daily',
                },
              },
            },
          },
        },
        {
          name = 'work',
          path = '~/vaults/work',
          overrides = {
            templates = {
              customizations = {
                daily = {
                  notes_subdir = 'daily',
                },
                meeting = {
                  notes_subdir = 'meetings',
                },
              },
            },
          },
        },
        {
          name = 'pop',
          path = '~/vaults/price-of-power',
          overrides = {
            templates = {
              customizations = {
                Organisation = {
                  notes_subdir = 'Organisations',
                },
                ['Combat Report'] = {
                  notes_subdir = 'Combat',
                },
                Session = {
                  notes_subdir = 'Sessions',
                },
                Affliction = {
                  notes_subdir = 'Afflictions',
                },
                Creature = {
                  notes_subdir = 'Creatures',
                },
                Day = {
                  notes_subdir = 'Days',
                },
                Location = {
                  notes_subdir = 'Locations',
                },
                Character = {
                  notes_subdir = 'Characters/Non-Player Characters',
                },
                ['Player Character'] = {
                  notes_subdir = 'Characters/Player Characters',
                },
              },
            },
          },
        },
        {
          name = 'cc',
          path = '~/vaults/cc',
          overrides = {
            templates = {
              customizations = {
                sessions = {
                  notes_subdir = 'sessions',
                },
                character = {
                  notes_subdir = 'characters',
                },
              },
            },
          },
        },
      },
      templates = {
        folder = 'ZZZ_Templates',
        date_format = '%Y-%m-%d-%a',
        time_format = '%H:%M',
      },
      callbacks = {
        enter_note = function(note)
          local obsidian = require 'obsidian'
          local bufnr = vim.api.nvim_get_current_buf()
          local workspace = note and obsidian.api.find_workspace(tostring(note.path)) or nil

          vim.keymap.set('n', '<leader>od', '<cmd>Obsidian today<cr>', {
            buffer = bufnr,
            desc = '[O]bsidian [D]aily note',
          })

          vim.keymap.set('n', '<leader>ot', '<cmd>Obsidian new_from_template<cr>', {
            buffer = bufnr,
            desc = '[O]bsidian note from [T]emplate',
          })

          vim.keymap.set('n', '<leader>oW', '<cmd>Obsidian workspace<cr>', {
            buffer = bufnr,
            desc = '[O]bsidian [W]orkspace',
          })

          if workspace and workspace.name == 'pop' then
            if not vim.b[bufnr].obsidian_pop_day_bound then
              vim.api.nvim_buf_create_user_command(
                bufnr,
                'ObsidianNewDay',
                function() create_pop_day_note(bufnr) end,
                { desc = 'Create a Price of Power day note' }
              )
              vim.b[bufnr].obsidian_pop_day_bound = true
            end

            vim.keymap.set('n', '<leader>oD', function() create_pop_day_note(bufnr) end, { buffer = bufnr, desc = '[O]bsidian [D]ay note' })
          end
        end,
      },
      sync = {
        enabled = true,
      },
    },
    config = function(_, opts) require('obsidian').setup(opts) end,
  },
}
