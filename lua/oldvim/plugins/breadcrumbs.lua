return {
  'LunarVim/breadcrumbs.nvim',
  enabled = false,
  event = 'VeryLazy',
  config = function()
    require('breadcrumbs').setup()
  end,
}
