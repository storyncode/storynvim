StoryNvimPhase03 = StoryNvimPhase03 or {}

local function fail(message)
  error(message, 2)
end

local function assert_equal(actual, expected, label)
  if actual ~= expected then
    fail(string.format('%s: expected %s, got %s', label, vim.inspect(expected), vim.inspect(actual)))
  end
end

local function assert_truthy(value, label)
  if not value then
    fail(label)
  end
end

local function maparg(lhs, mode)
  local mapping = vim.fn.maparg(lhs, mode, false, true)
  assert_truthy(type(mapping) == 'table' and not vim.tbl_isempty(mapping), string.format('missing mapping for %s in mode %s', lhs, mode))
  return mapping
end

local function resolved_config_root()
  local source = debug.getinfo(require('story.bootstrap').setup, 'S').source:sub(2)
  source = vim.uv.fs_realpath(source) or source
  return vim.fs.dirname(vim.fs.dirname(vim.fs.dirname(source)))
end

function StoryNvimPhase03.run_core01()
  vim.wait(100)

  assert_equal(vim.o.number, true, 'number option')
  assert_equal(vim.o.signcolumn, 'yes', 'signcolumn option')
  assert_equal(vim.o.scrolloff, 10, 'scrolloff option')
  assert_equal(vim.o.list, true, 'list option')
  assert_equal(vim.opt.listchars:get().tab, '» ', 'listchars.tab')
  assert_equal(vim.opt.listchars:get().trail, '·', 'listchars.trail')
  assert_equal(vim.opt.listchars:get().nbsp, '␣', 'listchars.nbsp')

  local config = vim.diagnostic.config()
  assert_equal(config.update_in_insert, false, 'diagnostic update_in_insert')
  assert_equal(config.severity_sort, true, 'diagnostic severity_sort')
  assert_equal(config.float.border, 'rounded', 'diagnostic float border')
  assert_equal(config.float.source, 'if_many', 'diagnostic float source')
  assert_equal(config.virtual_text, true, 'diagnostic virtual_text')
  assert_equal(config.virtual_lines, false, 'diagnostic virtual_lines')
  assert_equal(config.underline.severity.min, vim.diagnostic.severity.WARN, 'diagnostic underline severity')

  local quickfix = maparg('<leader>q', 'n')
  assert_equal(quickfix.desc, 'Open diagnostic [Q]uickfix list', 'diagnostic quickfix description')
end

function StoryNvimPhase03.run_core02()
  local search_clear = maparg('<Esc>', 'n')
  assert_truthy(search_clear.rhs == '<Cmd>nohlsearch<CR>' or search_clear.rhs == '<cmd>nohlsearch<CR>', 'search clear rhs mismatch')

  local terminal_exit = maparg('<Esc><Esc>', 't')
  assert_equal(terminal_exit.rhs, '<C-\\><C-n>', 'terminal exit rhs')
  assert_equal(terminal_exit.desc, 'Exit terminal mode', 'terminal exit description')

  local left = maparg('<C-h>', 'n')
  local down = maparg('<C-j>', 'n')
  local up = maparg('<C-k>', 'n')
  local right = maparg('<C-l>', 'n')

  assert_equal(left.rhs, '<C-w><C-h>', 'left split rhs')
  assert_equal(left.desc, 'Move focus to the left window', 'left split description')
  assert_equal(down.rhs, '<C-w><C-j>', 'down split rhs')
  assert_equal(down.desc, 'Move focus to the lower window', 'down split description')
  assert_equal(up.rhs, '<C-w><C-k>', 'up split rhs')
  assert_equal(up.desc, 'Move focus to the upper window', 'up split description')
  assert_equal(right.rhs, '<C-w><C-l>', 'right split rhs')
  assert_equal(right.desc, 'Move focus to the right window', 'right split description')
end

function StoryNvimPhase03.run_core03()
  vim.wait(100)

  local autocmds = vim.api.nvim_get_autocmds({ group = 'kickstart-highlight-yank' })
  assert_truthy(#autocmds > 0, 'missing yank highlight autocmd group')
  assert_equal(vim.o.clipboard, 'unnamedplus', 'clipboard sync')

  local config_root = resolved_config_root()
  assert_truthy(vim.tbl_contains(vim.opt.rtp:get(), config_root), 'runtimepath missing resolved config root: ' .. config_root)

  local lazy_ok = pcall(require, 'lazy')
  assert_truthy(lazy_ok, 'lazy bootstrap did not finish')
end

function StoryNvimPhase03.run_all()
  StoryNvimPhase03.run_core01()
  StoryNvimPhase03.run_core02()
  StoryNvimPhase03.run_core03()
end
