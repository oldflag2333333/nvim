local autocmd = require('oldvim.util').autocmd
local bind = require('oldvim.util').bind
return {
  'stevearc/oil.nvim',
  enabled = false,
  opts = {},
  -- Optional dependencies
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    autocmd('FileType', {
      pattern = 'oil',
      callback = function()
        vim.opt_local.colorcolumn = ''
      end,
    })
    local oil = require 'oil'
    oil.setup {
      use_default_keymaps = false,
      keymaps = {
        ['g?'] = 'actions.show_help',
        ['<CR>'] = 'actions.select',
        ['-'] = 'actions.parent',
        ['='] = 'actions.select',
        ['<C-\\>'] = 'actions.select_split',
        ['<C-enter>'] = 'actions.select_vsplit', -- this is used to navigate left
        ['<C-t>'] = 'actions.select_tab',
        ['<C-p>'] = 'actions.preview',
        ['<C-c>'] = 'actions.close',
        ['<C-r>'] = 'actions.refresh',
        ['_'] = 'actions.open_cwd',
        ['`'] = 'actions.cd',
        ['~'] = 'actions.tcd',
        ['gs'] = 'actions.change_sort',
        ['gx'] = 'actions.open_external',
        ['g.'] = 'actions.toggle_hidden',
      },
      view_options = {
        show_hidden = true,
      },
    }
    local toggle = function()
      oil.toggle_float()
    end
    bind('n', '<leader>e', toggle, { desc = 'Toggle Oil' })
  end,
}
