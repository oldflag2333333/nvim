local M = {
  'nvim-treesitter/nvim-treesitter',
  enabled = true,
  dev = true,
  init = function(plugin)
    require('lazy.core.loader').add_to_rtp(plugin)
  end,
  dependencies = {
    {
      'nvim-treesitter/nvim-treesitter-textobjects',
      config = function()
        require('nvim-treesitter-textobjects').setup()

        local move = require 'nvim-treesitter-textobjects.move'

        local function make_diff_wrapper(func)
          return function(query, ...)
            if vim.wo.diff then
              local key = vim.fn.keytrans(vim.api.nvim_replace_termcodes('<C-]>', true, false, true))
              if key == ']' then
                return vim.cmd 'normal! ]c'
              elseif key == '[' then
                return vim.cmd 'normal! [c'
              end
            end
            return func(query, ...)
          end
        end

        local goto_next_start = make_diff_wrapper(move.goto_next_start)
        local goto_next_end = make_diff_wrapper(move.goto_next_end)
        local goto_previous_start = make_diff_wrapper(move.goto_previous_start)
        local goto_previous_end = make_diff_wrapper(move.goto_previous_end)

        local function set_keymaps()
          pcall(vim.keymap.del, 'n', ']fs')
          pcall(vim.keymap.del, 'n', ']fe')
          pcall(vim.keymap.del, 'n', ']cs')
          pcall(vim.keymap.del, 'n', ']ce')
          pcall(vim.keymap.del, 'n', '[fs')
          pcall(vim.keymap.del, 'n', '[fe')
          pcall(vim.keymap.del, 'n', '[cs')
          pcall(vim.keymap.del, 'n', '[ce')

          vim.keymap.set('n', ']fs', function()
            goto_next_start '@function.outer'
          end, { desc = 'Next function start' })
          vim.keymap.set('n', ']fe', function()
            goto_next_end '@function.outer'
          end, { desc = 'Next function end' })
          vim.keymap.set('n', ']cs', function()
            goto_next_start '@class.outer'
          end, { desc = 'Next class start' })
          vim.keymap.set('n', ']ce', function()
            goto_next_end '@class.outer'
          end, { desc = 'Next class end' })
          vim.keymap.set('n', '[fs', function()
            goto_previous_start '@function.outer'
          end, { desc = 'Previous function start' })
          vim.keymap.set('n', '[fe', function()
            goto_previous_end '@function.outer'
          end, { desc = 'Previous function end' })
          vim.keymap.set('n', '[cs', function()
            goto_previous_start '@class.outer'
          end, { desc = 'Previous class start' })
          vim.keymap.set('n', '[ce', function()
            goto_previous_end '@class.outer'
          end, { desc = 'Previous class end' })
        end

        vim.api.nvim_create_autocmd('FileType', {
          pattern = '*',
          callback = function()
            if pcall(require, 'nvim-treesitter-textobjects') then
              set_keymaps()
            end
          end,
        })
      end,
    },
  },
  config = function()
    local parser_dir = vim.fn.stdpath 'data' .. '/nix/nvim-treesitter'

    local parser_path = parser_dir .. '/parser'
    if vim.fn.isdirectory(parser_path) == 0 then
      vim.notify('Treesitter parsers not found at: ' .. parser_path, vim.log.levels.WARN)
    end

    require('nvim-treesitter').setup {
      install_dir = parser_dir,
    }

    vim.api.nvim_create_autocmd('FileType', {
      pattern = '*',
      callback = function()
        if pcall(function()
          return vim.treesitter.get_parser()
        end) then
          vim.treesitter.start()
        end
      end,
    })

    vim.api.nvim_create_autocmd('FileType', {
      pattern = '*',
      callback = function()
        if pcall(require, 'nvim-treesitter') then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}

return M
