local M = {}

function M.setup(capabilities)
  local rust_analyzer = {
    capabilities = capabilities,
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
    settings = {
      ['rust-analyzer'] = {
        cargo = {
          allFeatures = true,
        },
        check = {
          command = 'clippy',
        },
      },
    },
  }

  vim.lsp.config.rust_analyzer = rust_analyzer
  vim.lsp.enable 'rust_analyzer'
end

return M
