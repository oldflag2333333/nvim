local M = {}

local mt = {
  __index = M,
  __newindex = function(_, key, value)
    rawset(M, key, value)
  end,
}

setmetatable(M, mt)

M.bind = function(mode, lhs, rhs, opts)
  opts = opts or {}
  -- default to true
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

M.augroup = function(name)
  return vim.api.nvim_create_augroup('oldvim_' .. name, { clear = true })
end

M.autocmd = vim.api.nvim_create_autocmd

M.root = require 'oldvim.util.root'

M.lsp = require 'oldvim.util.lsp'

-- Utility function to extend or override a config table, similar to the way
-- that Plugin.opts works.
---@param config table
---@param custom function | table | nil
M.extend_or_override = function(config, custom, ...)
  if type(custom) == 'function' then
    config = custom(config, ...) or config
  elseif custom then
    config = vim.tbl_deep_extend('force', config, custom) --[[@as table]]
  end
  return config
end

---@param template string
---@param data table
function M.render_template(template, data)
  return (string.gsub(template, '${(.-)}', data))
end

---@param collection string[]
---@param value string
function M.contains(collection, value)
  for _, pattern in ipairs(collection) do
    if string.match(value, pattern) then
      return true
    end
  end
  return false
end

return M
