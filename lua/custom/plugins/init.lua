-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- Start with README.md for the current architecture guide.
-- `lua/custom/plugins/` is the stable place for your fork-local plugin specs,
-- overrides, and experiments without editing the shipped `lua/plugins/` modules.

---@module 'lazy'
---@type LazySpec
return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    keys = {
      { '<leader>El', '<cmd>Neotree filesystem reveal left<cr>', desc = '[E]xplorer open [l]eft', silent = true },
    },
  },
}
