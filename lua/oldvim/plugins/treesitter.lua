local M = {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  enabled = true,
  lazy = false,
  init = function(plugin)
    require('lazy.core.loader').add_to_rtp(plugin)
  end,
  dependencies = {
    {
      'nvim-treesitter/nvim-treesitter-textobjects',
      branch = 'main',
      config = function()
        require('nvim-treesitter-textobjects').setup {
          move = {
            set_jumps = true,
          },
        }

        -- Diff-aware textobject motion keymaps
        local move = require 'nvim-treesitter-textobjects.move'

        local function make_diff_wrapper(func)
          return function(query, ...)
            if vim.wo.diff then
              local key = vim.fn.keytrans(
                vim.api.nvim_replace_termcodes('<C-]>', true, false, true)
              )
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

        local map = require('oldvim.util').bind

        local function set_keymaps()
          pcall(vim.keymap.del, 'n', ']fs')
          pcall(vim.keymap.del, 'n', ']fe')
          pcall(vim.keymap.del, 'n', ']cs')
          pcall(vim.keymap.del, 'n', ']ce')
          pcall(vim.keymap.del, 'n', '[fs')
          pcall(vim.keymap.del, 'n', '[fe')
          pcall(vim.keymap.del, 'n', '[cs')
          pcall(vim.keymap.del, 'n', '[ce')

          map('n', ']fs', function()
            goto_next_start '@function.outer'
          end, { desc = 'Next function start' })
          map('n', ']fe', function()
            goto_next_end '@function.outer'
          end, { desc = 'Next function end' })
          map('n', ']cs', function()
            goto_next_start '@class.outer'
          end, { desc = 'Next class start' })
          map('n', ']ce', function()
            goto_next_end '@class.outer'
          end, { desc = 'Next class end' })
          map('n', '[fs', function()
            goto_previous_start '@function.outer'
          end, { desc = 'Previous function start' })
          map('n', '[fe', function()
            goto_previous_end '@function.outer'
          end, { desc = 'Previous function end' })
          map('n', '[cs', function()
            goto_previous_start '@class.outer'
          end, { desc = 'Previous class start' })
          map('n', '[ce', function()
            goto_previous_end '@class.outer'
          end, { desc = 'Previous class end' })
        end

        vim.api.nvim_create_autocmd('FileType', {
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
    -- On `main` branch, setup() is optional and only accepts install_dir
    -- and local_parsers. Since parsers are managed by Nix (symlinked to
    -- ~/.local/share/nvim/lazy/nvim-treesitter/parser/, on runtimepath),
    -- no setup() call is needed.
    --
    -- Features (highlight, indent, fold) are enabled via Neovim core API
    -- and nvim-treesitter's indentexpr(), NOT via setup{} options.
    --
    -- vim.treesitter.language.add() returns true iff the parser is
    -- available, so it safely guards against filetypes like dashboard,
    -- neo-tree, toggleterm that don't have tree-sitter parsers.

    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
        if not lang or not vim.treesitter.language.add(lang) then
          return
        end

        vim.treesitter.start(args.buf)

        vim.bo[args.buf].indentexpr =
          "v:lua.require'nvim-treesitter'.indentexpr()"

        vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo[0][0].foldmethod = 'expr'
      end,
    })
  end,
}

return M
