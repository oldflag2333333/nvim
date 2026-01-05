-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
-- There are additional nvim-treesitter modules that you can use to interact
-- with nvim-treesitter. You should go explore a few and see what interests you:
--
-- Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
-- Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
-- Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
local M = {
  'nvim-treesitter/nvim-treesitter',
  enabled = false,
  dev = true,
  version = false,
  main = 'nvim-treesitter.configs',
  event = 'VeryLazy',
  init = function(plugin)
    require('lazy.core.loader').add_to_rtp(plugin)
    require 'nvim-treesitter.query_predicates'
  end,
  dependencies = {
    {
      'nvim-treesitter/nvim-treesitter-textobjects',
      lazy = true,
      config = function()
        -- When in diff mode, we want to use the default
        -- vim text objects c & C instead of the treesitter ones.
        local move = require 'nvim-treesitter.textobjects.move' ---@type table<string,fun(...)>
        local configs = require 'nvim-treesitter.configs'
        for name, fn in pairs(move) do
          if name:find 'goto' == 1 then
            move[name] = function(q, ...)
              if vim.wo.diff then
                local config = configs.get_module('textobjects.move')[name] ---@type table<string,string>
                for key, query in pairs(config or {}) do
                  if q == query and key:find '[%]%[][cC]' then
                    vim.cmd('normal! ' .. key)
                    return
                  end
                end
              end
              return fn(q, ...)
            end
          end
        end
      end,
    },
  },
  keys = {
    { '<c-space>', desc = 'Increment selection' },
    { '<bs>', desc = 'Decrement selection', mode = 'x' },
  },
  opts = {
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<C-space>',
        node_incremental = '<C-space>',
        scope_incremental = false,
        node_decremental = '<bs>',
      },
    },
    textobjects = {
      move = {
        enable = true,
        goto_next_start = { [']fs'] = '@function.outer', [']cs'] = '@class.outer' },
        goto_next_end = { [']fe'] = '@function.outer', [']ce'] = '@class.outer' },
        goto_previous_start = { ['[fs'] = '@function.outer', ['[cs'] = '@class.outer' },
        goto_previous_end = { ['[fe'] = '@function.outer', ['[ce'] = '@class.outer' },
      },
    },
  },
}

return M
