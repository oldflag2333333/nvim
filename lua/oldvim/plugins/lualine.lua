-- Copyright (c) 2020-2021 hoob3rt
-- MIT license, see LICENSE for more details.
local mode = {}

-- stylua: ignore
mode.map = {
  ['n']      = 'NORM',
  ['no']     = 'O-PENDING',
  ['nov']    = 'O-PENDING',
  ['noV']    = 'O-PENDING',
  ['no\22'] = 'O-PENDING',
  ['niI']    = 'NORM',
  ['niR']    = 'NORM',
  ['niV']    = 'NORM',
  ['nt']     = 'NORM',
  ['ntT']    = 'NORM',
  ['v']      = 'VISU',
  ['vs']     = 'VISU',
  ['V']      = 'V-LINE',
  ['Vs']     = 'V-LINE',
  ['\22']   = 'V-BLOCK',
  ['\22s']  = 'V-BLOCK',
  ['s']      = 'SELECT',
  ['S']      = 'S-LINE',
  ['\19']   = 'S-BLOCK',
  ['i']      = 'INST',
  ['ic']     = 'INST',
  ['ix']     = 'INST',
  ['R']      = 'REPL',
  ['Rc']     = 'REPL',
  ['Rx']     = 'REPL',
  ['Rv']     = 'V-REPL',
  ['Rvc']    = 'V-REPL',
  ['Rvx']    = 'V-REPL',
  ['c']      = 'COMMAND',
  ['cv']     = 'EX',
  ['ce']     = 'EX',
  ['r']      = 'REPL',
  ['rm']     = 'MORE',
  ['r?']     = 'CONFIRM',
  ['!']      = 'SHELL',
  ['t']      = 'TERM',
}

---@return string current mode name
function mode.get_mode()
  local mode_code = vim.api.nvim_get_mode().mode
  if mode.map[mode_code] == nil then
    return mode_code
  end
  return mode.map[mode_code]
end

return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local opts = {
      options = {
        theme = 'auto',
        -- section_separators = { left = '', right = '' },
        -- component_separators = { left = '│', right = '│' },
        -- component_separators = { left = '', right = '' },
        globalstatus = true,
        disabled_filetypes = {
          statusline = { 'dashboard', 'alpha', 'starter' },
        },
      },
      sections = {
        lualine_a = { mode.get_mode },
        -- lualine_b = { 'branch', 'diagnostics' },
      },
    }
    require('lualine').setup(opts)
  end,
}
