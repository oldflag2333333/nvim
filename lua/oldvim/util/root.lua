local M = {}

function M.get_root(specs)
  -- TODO: when lsp is availabe, perfer lsp.
  specs = specs or { '.git', '.workspace', 'init.lua' }
  return vim.fs.dirname(vim.fs.find(specs, { upward = true })[1])
end

return M
