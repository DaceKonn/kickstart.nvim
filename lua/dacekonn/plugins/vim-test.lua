return {
  'vim-test/vim-test',
  config = function()
    -- vim.api.nvim_set_keymap('n', '<leader>tn', ':TestNearest<CR>', { noremap = true, silent = true })
    local wk = require 'which-key'
    wk.add({
      ['<leader>x'] = {
        name = 'xxx',
        x = { '<cmd>Telescope find_files<cr>', 'Find File' },
        z = { name = 'zzz', z = { '<cmd>Telescope live_grep<cr>', 'Grep' }, y = { '<cmd>Telescope current_buffer_fuzzy_find<cr>', 'Buffer' } },
      },
    }, { prefix = '<leader>' })
  end,
}
