return {
    'folke/which-key.nvim',
    event = 'VimEnter',
    config = function()
        -- gain access to the which key plugin
        local which_key = require('which-key')

        -- call the setup function with default properties
        which_key.setup()

        which_key.add({
            { '<leader>/', desc = '[/] Comments' },
            { '<leader>c', desc = '[C]ode' },
            { '<leader>d', desc = '[D]ebug' },
            { '<leader>e', desc = '[E]xplorer' },
            { '<leader>f', desc = '[F]ind' },
            { '<leader>g', desc = '[G]it' },
            { '<leader>J', desc = '[J]ava' },
            { '<leader>w', desc = '[W]indow' },
        })

        
    end
}
