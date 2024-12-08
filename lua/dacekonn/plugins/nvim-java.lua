-- ~/.config/nvim/lua/plugins/nvim-java.lua
return {
  'nvim-java/nvim-java',
  config = function()
    require('nvim-java').setup {
      -- Your custom configuration here
      server_dir = '', -- Set the directory to the Java language server
      lsp_diagnostics = true, -- Enable LSP diagnostics
      mappings = {
        { 'n', '<leader>jr', require('nvim-java').run_main, { noremap = true, silent = true } },
        { 'n', '<leader>jt', require('nvim-java').run_test, { noremap = true, silent = true } },
      },
    }
  end,
  requires = {
    'neovim/nvim-lspconfig',
    'mfussenegger/nvim-dap',
    'nvim-telescope/telescope.nvim',
  },
}
