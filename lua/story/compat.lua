local M = {}

function M.assert_phase04_full()
  local cfg = require 'lazy.core.config'
  -- Registry parity contract: telescope.nvim, nvim%-lspconfig, blink.cmp, conform.nvim, nvim%-treesitter, gitsigns.nvim.
  local shipped_plugins = {
    'telescope.nvim',
    'nvim-lspconfig',
    'blink.cmp',
    'conform.nvim',
    'nvim-treesitter',
    'gitsigns.nvim',
  }

  for _, name in ipairs(shipped_plugins) do
    assert(cfg.plugins[name], name)
  end

  -- Legacy/custom module contract: kickstart.plugins.debug, kickstart.plugins.lint, kickstart.plugins.gitsigns,
  -- kickstart.plugins.autopairs, kickstart.plugins.indent_line, kickstart.plugins.neo%-tree, custom.plugins.
  assert(type(require('kickstart.plugins.debug')) == 'table', 'kickstart.plugins.debug')
  assert(type(require('kickstart.plugins.lint')) == 'table', 'kickstart.plugins.lint')
  assert(type(require('kickstart.plugins.gitsigns')) == 'table', 'kickstart.plugins.gitsigns')
  assert(type(require('kickstart.plugins.autopairs')) == 'table', 'kickstart.plugins.autopairs')
  assert(type(require('kickstart.plugins.indent_line')) == 'table', 'kickstart.plugins.indent_line')
  assert(type(require('kickstart.plugins.neo-tree')) == 'table', 'kickstart.plugins.neo-tree')
  assert(type(require('custom.plugins')) == 'table', 'custom.plugins')

  -- Runtime parity contract: <leader>sh, <leader><leader>, kickstart%-highlight%-yank, LspAttach, clipboard == 'unnamedplus'.
  assert(vim.fn.maparg('<leader>sh', 'n', false, true).lhs == '<Space>sh', '<leader>sh')
  assert(vim.fn.maparg('<leader><leader>', 'n', false, true).lhs == '<Space><Space>', '<leader><leader>')
  assert(#vim.api.nvim_get_autocmds({ group = 'kickstart-highlight-yank' }) > 0, 'kickstart-highlight-yank')
  assert(#vim.api.nvim_get_autocmds({ event = 'LspAttach' }) > 0, 'LspAttach')
  assert(vim.o.clipboard == 'unnamedplus', "clipboard == 'unnamedplus'")
  assert(pcall(require, 'conform'), 'conform')
end

return M
