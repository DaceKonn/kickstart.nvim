return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'nvimtools/none-ls-extras.nvim',
  },
  config = function()
    -- get access to the none-ls functions -> yes, it's correct it should be null-ls
    local null_ls = require 'null-ls'

    null_ls.setup {
      sources = {
        null_ls.builtins.formatting.stylua, --lua
        require 'none-ls.diagnostics.eslint_d', -- javascript
        null_ls.builtins.formatting.prettier, -- anything else
      },
    }

    vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, { desc = '[C]ode [F]ormat' })
  end,
}
