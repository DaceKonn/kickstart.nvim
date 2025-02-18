return {
  'elmcgill/springboot-nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
    'mfussenegger/nvim-jdtls',
  },
  config = function()
    -- access spring boot nvim plugin functions
    local springboot_nvim = require 'springboot-nvim'

    -- set a vim motion to run the spring boot project in a vim terminal
    vim.keymap.set('n', '<leader>Jr', springboot_nvim.boot_run, { desc = '[J]ava [R]un Spring Boot' })
    -- set a vim motion to open the generate class ui to create a class
    vim.keymap.set('n', '<leader>Jcc', springboot_nvim.generate_class, { desc = '[J]ava [C]reate [C]lass' })
    -- set a vim motion to open the generate interface ui
    vim.keymap.set('n', '<leader>Jci', springboot_nvim.generate_interface, { desc = '[J]ava [C]reate [I]nterface}' })
    -- set a vim motion to open ui to generate enum
    vim.keymap.set('n', '<leader>Jce', springboot_nvim.generate_enum, { desc = '[J]ava [C]reate [E]num' })

    springboot_nvim.setup {}
  end,
}
