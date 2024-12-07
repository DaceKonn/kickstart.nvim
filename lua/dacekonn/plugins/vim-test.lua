return {
  'vim-test/vim-test',
  config = function()
    vim.api.nvim_set_keymap('n', '<leader>Tn', ':TestNearest<CR>', { noremap = true, silent = true, desc = 'Test [N]earest' })
    vim.api.nvim_set_keymap('n', '<leader>Tc', ':TestClass<CR>', { noremap = true, silent = true, desc = 'Test [C]ass' })
    vim.api.nvim_set_keymap('n', '<leader>Tf', ':TestFile<CR>', { noremap = true, silent = true, desc = 'Test [F]tile' })
    vim.api.nvim_set_keymap('n', '<leader>Tl', ':TestLast<CR>', { noremap = true, silent = true, desc = 'Test [L]ast' })
    vim.api.nvim_set_keymap('n', '<leader>Ts', ':TestSuite<CR>', { noremap = true, silent = true, desc = 'Test [S]uite' })
    vim.api.nvim_set_keymap('n', '<leader>Tv', ':TestVisit<CR>', { noremap = true, silent = true, desc = 'Test [V]isit' })
  end,
}
