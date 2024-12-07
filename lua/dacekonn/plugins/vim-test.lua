return {
  'vim-test/vim-test',
  config = function()
    vim.api.nvim_set_keymap('n', '<leader>tn', ':TestNearest<CR>', { noremap = true, silent = true })
  end,
}
