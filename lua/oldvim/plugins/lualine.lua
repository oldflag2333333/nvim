return {
  'nvim-lualine/lualine.nvim',
  enabled = true,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local opts = {
      options = {
        theme = 'auto',
        globalstatus = true,
        disabled_filetypes = {
          statusline = { 'dashboard', 'alpha', 'starter' },
        },
      },
    }
    require('lualine').setup(opts)
  end,
}
