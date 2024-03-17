local M = {}

local default_opt = {
  silent = true,
  noremap = true,
}

M.bind = function(mode, lhs, rhs, opt)
  opt = opt or default_opt
  vim.keymap.set(mode, lhs, rhs, opt)
end

M.augroup = function(name)
  return vim.api.nvim_create_augroup('oldvim_' .. name, { clear = true })
end

M.autocmd = vim.api.nvim_create_autocmd

-- M.lsp = require 'oldvim.util.lsp'

M.root = require 'oldvim.util.root'

return M
