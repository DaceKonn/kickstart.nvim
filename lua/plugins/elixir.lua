return {
    -- Enhanced Elixir support with additional features
    {
        "elixir-tools/elixir-tools.nvim",
        version = "*",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local elixir = require("elixir")
            local elixirls = require("elixir.elixirls")

            elixir.setup {
                nextls = {
                    enable = false, -- defaults to false, we're using elixirls instead
                },
                credo = {
                    enable = true, -- Enable Credo linting
                },
                elixirls = {
                    enable = true,
                    settings = elixirls.settings {
                        dialyzerEnabled = false,
                        enableTestLenses = false,
                        suggestSpecs = false,
                        fetchDeps = false,
                    },
                },
            }
        end,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
    -- Test runner for Elixir
    {
        "jfpedroza/neotest-elixir",
        dependencies = {
            "nvim-neotest/neotest",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter"
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-elixir")
                }
            })
            
            -- Key mappings for testing
            vim.keymap.set("n", "<leader>tt", function()
                require("neotest").run.run()
            end, { desc = "[T]est Run Nearest" })
            
            vim.keymap.set("n", "<leader>tf", function()
                require("neotest").run.run(vim.fn.expand("%"))
            end, { desc = "[T]est Run [F]ile" })
            
            vim.keymap.set("n", "<leader>ta", function()
                require("neotest").run.run(vim.fn.getcwd())
            end, { desc = "[T]est Run [A]ll" })
            
            vim.keymap.set("n", "<leader>ts", function()
                require("neotest").summary.toggle()
            end, { desc = "[T]est [S]ummary" })
            
            vim.keymap.set("n", "<leader>to", function()
                require("neotest").output.open({ enter = true, auto_close = true })
            end, { desc = "[T]est [O]utput" })
        end,
    },
}
