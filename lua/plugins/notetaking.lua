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

local function resolve_obsidian_workspace()
  local obsidian = require 'obsidian'
  local bufname = vim.api.nvim_buf_get_name(0)
  local workspace = nil

  if bufname ~= '' then workspace = obsidian.api.find_workspace(bufname) end
  if not workspace then workspace = obsidian.Workspace.find(vim.fn.getcwd(), Obsidian.workspaces) end

  return obsidian, workspace
end

local function with_resolved_workspace(callback)
  local obsidian, workspace = resolve_obsidian_workspace()
  if not workspace then
    vim.notify('No configured Obsidian workspace found for current buffer or cwd', vim.log.levels.WARN)
    return
  end

  if not Obsidian.workspace or Obsidian.workspace.name ~= workspace.name then obsidian.Workspace.set(workspace) end

  callback(obsidian, workspace)
end

---@module 'lazy'
---@type LazySpec
return {
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
            daily_notes = {
              folder = 'daily',
              template = 'daily',
            },
            templates = {
              customizations = {
                daily = {
                  notes_subdir = 'daily',
                },
                project = {
                  notes_subdir = 'projects',
                },
                idea = {
                  notes_subdir = 'ideas',
                },
              },
            },
          },
        },
        {
          name = 'work',
          path = '~/vaults/work',
          overrides = {
            daily_notes = {
              folder = 'daily',
              template = 'daily',
            },
            templates = {
              customizations = {
                daily = {
                  notes_subdir = 'daily',
                },
                meeting = {
                  notes_subdir = 'meetings',
                },
                employee = {
                  notes_subdir = 'employees',
                },
                investigation = {
                  notes_subdir = 'investionations',
                },
                release = {
                  notes_subdir = 'releases',
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
        {
          name = 'scratchpad',
          path = '~/vaults/scratch',
          overrides = {
            templates = {
              customizations = {
                daily = {
                  notes_subdir = 'daily',
                },
                idea = {
                  notes_subdir = 'ideas',
                },
                project = {
                  notes_subdir = 'projects',
                },
              },
            },
          },
        },
        {
          name = 'hellbreakers',
          path = '~/vaults/hellbreakers',
          overrides = {
            customizations = {
              templates = {
                session = {
                  notes_subdir = 'Session',
                },
                player_character = {
                  notes_subdir = 'Player Characters',
                },
                creature = {
                  notes_subdir = 'Creatures',
                },
                organisation = {
                  notes_subdir = 'Organisations',
                },
                location = {
                  notes_subdir = 'Locations',
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
      sync = {
        enabled = true,
      },
    },
    config = function(_, opts)
      require('obsidian').setup(opts)

      vim.keymap.set('n', '<leader>od', function()
        with_resolved_workspace(function() vim.cmd 'Obsidian today' end)
      end, { desc = '[O]bsidian [D]aily note' })

      vim.keymap.set('n', '<leader>oT', function()
        with_resolved_workspace(function() vim.cmd 'Obsidian new_from_template' end)
      end, { desc = '[O]bsidian note from [T]emplate' })

      vim.keymap.set('n', '<leader>ot', function()
        with_resolved_workspace(function() vim.cmd 'Obsidian template' end)
      end, { desc = '[O]bsidian apply [t]emplate' })

      vim.keymap.set('n', '<leader>oW', '<cmd>Obsidian workspace<cr>', {
        desc = '[O]bsidian [W]orkspace',
      })

      vim.keymap.set('n', '<leader>om', function()
        with_resolved_workspace(function(obsidian, workspace)
          if workspace.name ~= 'work' then
            vim.notify('Meeting template is only configured for the work vault', vim.log.levels.WARN)
            return
          end

          obsidian.actions.new_from_template(nil, 'meeting')
        end)
      end, { desc = '[O]bsidian [m]eeting' })

      vim.keymap.set('n', '<leader>oD', function()
        with_resolved_workspace(function(_, workspace)
          if workspace.name ~= 'pop' then
            vim.notify('Day note helper is only configured for the Price of Power vault', vim.log.levels.WARN)
            return
          end

          create_pop_day_note(0)
        end)
      end, { desc = '[O]bsidian [D]ay note' })
    end,
  },
}
