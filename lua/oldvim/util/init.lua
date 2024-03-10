local M = {}

M.bind = vim.keymap.set

M.augroup = function(name)
  return vim.api.nvim_create_augroup('oldvim_' .. name, { clear = true })
end

M.autocmd = vim.api.nvim_create_autocmd

-- M.lsp = require 'oldvim.util.lsp'

M.root = require 'oldvim.util.root'

return M
