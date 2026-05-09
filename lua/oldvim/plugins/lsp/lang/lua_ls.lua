local M = {}

function M.setup(capabilities)
  -- For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
  local lua_ls = {
    -- cmd = {...},
    -- filetypes { ...},
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        workspace = {
          checkThirdParty = false,
          library = vim.api.nvim_get_runtime_file('', true),
        },
        completion = {
          callSnippet = 'Replace',
        },
        -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        diagnostics = {
          disable = { 'missing-fields' },
          globals = { 'vim' },
        },
      },
    },
  }
  vim.lsp.config.lua_ls = lua_ls
  vim.lsp.enable 'lua_ls'
end

return M
