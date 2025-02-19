return {
    "nvim-tree/nvim-tree.lua",
    config = function()
        vim.keymap.set('n', '<leader>e', "<cmd>NvimTreeToggle<CR>", {desc = "Toggle [E]xplorer"})
        require("nvim-tree").setup({
            hijack_netrw = true,
            auto_reload_on_write = true,
            renderer = {
                group_empty = true,
            },
            live_filter = {
                prefix = '[FILTER]: ',
                always_show_folders = true
            }
        })
    end
}
