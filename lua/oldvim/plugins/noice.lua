return {
  {
    'rcarriga/nvim-notify',
    enabled = false,
    keys = {
      {
        '<leader>un',
        function()
          local notify = require 'notify'
          notify.dismiss {
            silent = true,
            pending = true,
          }
        end,
        desc = 'Dismiss all Notifications',
      },
    },
    opts = {
      timeout = 2000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
  },

  {
    'folke/noice.nvim',
    lazy = false,
    enabled = false,
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    opts = {
      lsp = {
        override = {
          -- temporarily disabled because treesitter and lsp is not installed
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      routes = {
        {
          filter = {
            event = 'msg_show',
            kind = 'emsg',
            any = {
              -- Block illuminate error message.
              { find = 'vim%-illuminate: goto_(%l+)_reference hit (%u+) of the references' },
              -- Block search not found.
              { find = 'Pattern not found' },
            },
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = 'msg_show',
            kind = 'wmsg',
            any = {
              -- Block search not found.
              { find = 'search hit (%u+), continuing at (%u+)' },
            },
          },
          opts = { skip = true },
        },

        {
          filter = {
            event = 'msg_show',
            any = {
              { find = '%d+L, %d+B' },
              { find = '; after #%d+' },
              { find = '; before #%d+' },
            },
          },
          view = 'mini',
        },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
      },
    },
    -- stylua: ignore
    keys = { },
  },
}
