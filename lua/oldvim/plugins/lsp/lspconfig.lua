local M = { -- LSP Configuration & Plugins, see `:help lsp-vs-treesitter`
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'j-hui/fidget.nvim', opts = {} },
  },
  config = function()
    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP Specification.
    --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    local capabilities = require('oldvim.util.lsp').get_capabilities()

    -- See `:help lspconfig-all` for a list of all the pre-configured LSPs
    require('oldvim.plugins.lsp.lang.lua_ls').setup(capabilities)
    require('oldvim.plugins.lsp.lang.clangd').setup(capabilities)
  end,
}

return M
