local M = {}

local function contains(root, path)
  root = vim.fs.normalize(root)
  path = vim.fs.normalize(path)

  return path == root or vim.startswith(path, root .. '/')
end

local function get_lsp_root()
  local bufnr = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  local roots = {}

  for _, client in ipairs(vim.lsp.get_clients { bufnr = bufnr }) do
    if client.config.root_dir then
      table.insert(roots, client.config.root_dir)
    end

    for _, folder in ipairs(client.workspace_folders or {}) do
      table.insert(roots, vim.uri_to_fname(folder.uri))
    end
  end

  table.sort(roots, function(a, b)
    return #a > #b
  end)

  for _, root in ipairs(roots) do
    if bufname == '' or contains(root, bufname) then
      return root
    end
  end

  return roots[1]
end

function M.get_root(specs)
  local lsp_root = get_lsp_root()
  if lsp_root then
    return lsp_root
  end

  specs = specs or { '.git', '.workspace', 'init.lua' }
  local marker = vim.fs.find(specs, { upward = true })[1]
  return marker and vim.fs.dirname(marker) or vim.fn.getcwd()
end

return M
