local M = {}

function M.setup(lspconfig, capabilities)
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
          -- Tells lua_ls where to find all the Lua files that you have loaded
          -- for your neovim configuration.
          library = {
            '${3rd}/luv/library',
            vim.env.VIMRUNTIME,
            -- unpack(vim.api.nvim_get_runtime_file('', true)),
          },
          -- If lua_ls is really slow on your computer, you can try this instead:
          -- library = { vim.env.VIMRUNTIME },
        },
        completion = {
          callSnippet = 'Replace',
        },
        -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        diagnostics = { disable = { 'missing-fields' } },
      },
    },
  }
  lspconfig.lua_ls.setup(lua_ls)
end

return M