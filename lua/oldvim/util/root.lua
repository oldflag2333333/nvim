local M = {}

function M.get_root(specs)
  -- TODO: when lsp is availabe, perfer lsp.
  specs = specs or { '.git', '.workspace', 'init.lua' }
  local marker = vim.fs.find(specs, { upward = true })[1]
  return marker and vim.fs.dirname(marker) or vim.fn.getcwd()
end

return M
