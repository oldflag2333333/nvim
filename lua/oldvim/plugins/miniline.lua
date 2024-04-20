return {
  'echasnovski/mini.statusline',
  version = '*',
  enabled = false,
  config = function()
    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    local statusline = require 'mini.statusline'

    local opts = {
      -- Whether to use icons by default
      use_icons = true,

      -- Whether to set Vim's settings for statusline (make it always shown with
      -- 'laststatus' set to 2). To use global statusline in Neovim>=0.7.0, set
      -- this to `false` and 'laststatus' to 3.
      set_vim_settings = false,
    }

    statusline.setup(opts)

    -- make miniline global.
    vim.opt.laststatus = 3

    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function(_)
      return '%2l:%-2v'
    end

    local CTRL_S = vim.api.nvim_replace_termcodes('<C-S>', true, true, true)
    local CTRL_V = vim.api.nvim_replace_termcodes('<C-V>', true, true, true)

    -- stylua: ignore start
    local modes = setmetatable({
      ['n']     = { long = 'NORM',    short = 'N',    hl = 'MiniStatuslineModeNormal' },
      ['v']     = { long = 'VISL',    short = 'V',    hl = 'MiniStatuslineModeVisual' },
      ['V']     = { long = 'V-LINE',  short = 'V-L',  hl = 'MiniStatuslineModeVisual' },
      [CTRL_V]  = { long = 'V-BLOCK', short = 'V-B',  hl = 'MiniStatuslineModeVisual' },
      ['s']     = { long = 'SELE',    short = 'S',    hl = 'MiniStatuslineModeVisual' },
      ['S']     = { long = 'S-LINE',  short = 'S-L',  hl = 'MiniStatuslineModeVisual' },
      [CTRL_S]  = { long = 'S-BLOCK', short = 'S-B',  hl = 'MiniStatuslineModeVisual' },
      ['i']     = { long = 'INST',    short = 'I',    hl = 'MiniStatuslineModeInsert' },
      ['R']     = { long = 'REPL',    short = 'R',    hl = 'MiniStatuslineModeReplace' },
      ['c']     = { long = 'COMD',    short = 'C',    hl = 'MiniStatuslineModeCommand' },
      ['r']     = { long = 'PROM',    short = 'P',    hl = 'MiniStatuslineModeOther' },
      ['!']     = { long = 'SHEL',    short = 'Sh',   hl = 'MiniStatuslineModeOther' },
      ['t']     = { long = 'TERM',    short = 'T',    hl = 'MiniStatuslineModeOther' },
    }, {
      -- By default return 'Unknown' but this shouldn't be needed
      __index = function()
        return    { long = 'UNKN',    short = 'U',    hl = '%#MiniStatuslineModeOther#' }
      end,
    })
    -- stylua: ignore end

    statusline.section_mode = function(args)
      local mode_info = modes[vim.fn.mode()]
      local mode = statusline.is_truncated(args.trunc_width) and mode_info.short or mode_info.long
      return mode, mode_info.hl
    end
  end,
}
