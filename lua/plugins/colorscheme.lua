return {
    -- Shortened Github Url
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        
        -- Make sure to set the color scheme when neovim loads and configures the dracula plugin
        vim.cmd.colorscheme 'tokyonight-night'
        -- You can configure highlights by doing something like:
        vim.cmd.hi 'Comment gui=none'
    end
}
