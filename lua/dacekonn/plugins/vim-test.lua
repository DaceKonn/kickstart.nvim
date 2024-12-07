return {
  'vim-test/vim-test',
  config = function()
    vim.api.nvim_set_keymap('n', '<leader>Tn', ':TestNearest<CR>', { noremap = true, silent = true, desc = 'test [n]earest' })
    vim.api.nvim_set_keymap('n', '<leader>Tc', ':TestClass<CR>', { noremap = true, silent = true, desc = 'test [C]ass' })
    vim.api.nvim_set_keymap('n', '<leader>Tf', ':TestFile<CR>', { noremap = true, silent = true, desc = 'test [f]ile' })
    vim.api.nvim_set_keymap('n', '<leader>Tl', ':TestLast<CR>', { noremap = true, silent = true, desc = 'show [l]ast result' })
    vim.api.nvim_set_keymap('n', '<leader>Ts', ':TestSuite<CR>', { noremap = true, silent = true, desc = 'test [s]uite' })
    vim.api.nvim_set_keymap('n', '<leader>Tv', ':TestVisit<CR>', { noremap = true, silent = true, desc = '[v]isit last run' })
  end,
}
