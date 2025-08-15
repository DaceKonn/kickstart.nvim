return {
    "nvimtools/none-ls.nvim",
    dependencies = {
        "nvimtools/none-ls-extras.nvim",
    },
    config = function()
        -- get access to the none-ls functions
        local null_ls = require("null-ls")
        
        -- Build sources list conditionally
        local sources = {
            -- setup lua formatter
            null_ls.builtins.formatting.stylua,
            -- setup eslint linter for javascript
            require("none-ls.diagnostics.eslint_d"),
            -- setup prettier to format languages that are not lua
            null_ls.builtins.formatting.prettier,
        }
        
        -- Add Dart formatter if available
        local dart_formatter = null_ls.builtins.formatting.dart_format or null_ls.builtins.formatting.dartfmt
        if dart_formatter then
            table.insert(sources, dart_formatter)
        elseif vim.fn.executable("dart") == 1 then
            -- Custom dart formatter using the dart format command
            table.insert(sources, {
                method = null_ls.methods.FORMATTING,
                filetypes = { "dart" },
                generator = null_ls.formatter({
                    command = "dart",
                    args = { "format" },
                    to_stdin = true,
                }),
            })
        end
        
        -- Add Elixir formatter if available
        if vim.fn.executable("mix") == 1 then
            table.insert(sources, {
                method = null_ls.methods.FORMATTING,
                filetypes = { "elixir" },
                generator = null_ls.formatter({
                    command = "mix",
                    args = { "format", "-" },
                    to_stdin = true,
                }),
            })
        end
        
        -- run the setup function for none-ls to setup our different formatters
        null_ls.setup({
            sources = sources
        })

        -- set up a vim motion for <Space> + c + f to automatically format our code based on which langauge server is active
        vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "[C]ode [F]ormat" })
    end
}
