local M = {}

function M.setup(capabilities)
  -- capabilities.offsetEncoding = { 'utf-16' }

  local clangd = {
    keys = {
      -- { '<leader>cR', '<cmd>ClangdSwitchSourceHeader<cr>', desc = 'Switch Source/Header (C/C++)' },
    },
    capabilities = capabilities,
    cmd = {
      'clangd',
      '--background-index',
      '--clang-tidy',
      '--header-insertion=iwyu',
      '--completion-style=detailed',
      '--function-arg-placeholders',
      '--fallback-style=llvm',
    },
    init_options = {
      usePlaceholders = true,
      completeUnimported = true,
      clangdFileStatus = true,
    },
  }
  vim.lsp.config.clangd = clangd
  vim.lsp.enable('clangd')
end

return M
