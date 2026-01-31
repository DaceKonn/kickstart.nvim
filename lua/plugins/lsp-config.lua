return {
    {
        "williamboman/mason.nvim",
        config = function()
            -- setup mason with default properties
            require("mason").setup()
        end
    },
    -- mason lsp config utilizes mason to automatically ensure lsp servers you want installed are installed
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            -- ensure that we have lua language server, typescript launguage server, java language server, and java test language server are installed
            require("mason-lspconfig").setup({
                -- ts_ls is the new name for TypeScript LSP (tsserver was deprecated)
                -- Note: Dart LSP is handled by Flutter/Dart SDK directly, not through Mason
                ensure_installed = { "lua_ls", "ts_ls", "jdtls", "gopls", "elixirls", "ols" },
            })
        end
    },
    -- mason nvim dap utilizes mason to automatically ensure debug adapters you want installed are installed, mason-lspconfig will not automatically install debug adapters for us
    {
        "jay-babu/mason-nvim-dap.nvim",
        config = function()
            -- ensure the java debug adapter is installed
            require("mason-nvim-dap").setup({
                ensure_installed = { "java-debug-adapter", "java-test" }
            })
        end
    },
    -- utility plugin for configuring the java language server for us
    {
        "mfussenegger/nvim-jdtls",
        dependencies = {
            "mfussenegger/nvim-dap",
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons",
        }
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            -- get access to the lspconfig plugins functions
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()




            -- setup code context integration
            local navic = require("nvim-navic")
            local on_attach = function(client, bufnr)
                if client.server_capabilities.documentSymbolProvider then
                    navic.attach(client, bufnr)
                end
            end

            -- setup the lua language server
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })

            -- setup the typescript language server
            lspconfig.ts_ls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })

            -- setup gopls
            lspconfig.gopls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                cmd = { 'gopls' },
                filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
                settings = {
                    gopls = {
                        completeUnimported = true,
                        usePlaceholders = true,
                        analyses = {
                            unusedparams = true,
                        },
                    },
                },
            })

            -- setup dart language server
            lspconfig.dartls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                cmd = { "dart", "language-server", "--protocol=lsp" },
                filetypes = { "dart" },
                init_options = {
                    closingLabels = true,
                    flutterOutline = true,
                    onlyAnalyzeProjectsWithOpenFiles = true,
                    outline = true,
                    suggestFromUnimportedLibraries = true,
                },
                settings = {
                    dart = {
                        completeFunctionCalls = true,
                        showTodos = true,
                    },
                },
            })

            lspconfig.nushell.setup({
                cmd = { "nu", "--lsp" },
                filetypes = { "nu" },
                root_dir = lspconfig.util.find_git_ancestor,
                single_file_support = true,
                capabilities = capabilities
            })

            lspconfig.ols.setup({
                capabilities = capabilities,
                filetypes = { "odin" },
                init_options = {
                    checker_args = "-strict-style",
                    collections = {
                        { name = "shared", path = vim.fn.expand('$HOME/odin') }
                    },
                },
            })

            -- setup elixir language server (cross-platform)
            local function get_elixir_ls_cmd()
                -- Try Mason-installed ElixirLS first
                local mason_path = vim.fn.stdpath('data') .. '/mason/packages/elixir-ls'
                local language_server_script

                if vim.fn.has('win32') == 1 then
                    language_server_script = mason_path .. '/language_server.bat'
                else
                    language_server_script = mason_path .. '/language_server.sh'
                end

                if vim.fn.executable(language_server_script) == 1 then
                    return { language_server_script }
                end

                -- Fallback to system elixir-ls if available
                if vim.fn.executable('elixir-ls') == 1 then
                    return { 'elixir-ls' }
                end

                -- Windows system fallback
                if vim.fn.has('win32') == 1 and vim.fn.executable('language_server.bat') == 1 then
                    return { 'language_server.bat' }
                end

                return nil
            end

            local elixir_cmd = get_elixir_ls_cmd()
            if elixir_cmd then
                lspconfig.elixirls.setup({
                    capabilities = capabilities,
                    on_attach = on_attach,
                    cmd = elixir_cmd,
                    settings = {
                        elixirLS = {
                            dialyzerEnabled = false,
                            fetchDeps = false,
                            enableTestLenses = false,
                            suggestSpecs = false,
                        },
                    },
                })
            end

            vim.opt.winbar = "%!v:lua.require('nvim-navic').get_location()"

            -- Set vim motion for <Space> + c + h to show code documentation about the code the cursor is currently over if available
            vim.keymap.set("n", "<leader>ch", vim.lsp.buf.hover, { desc = "[C]ode [H]over Documentation" })
            -- Set vim motion for <Space> + c + d to go where the code/variable under the cursor was defined
            vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "[C]ode Goto [D]efinition" })
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "[G]oto [D]efinition" })
            -- Set vim motion for <Space> + c + a for display code action suggestions for code diagnostics in both normal and visual mode
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ctions" })
            -- Set vim motion for <Space> + c + r to display references to the code under the cursor
            vim.keymap.set("n", "<leader>cr", require("telescope.builtin").lsp_references,
                { desc = "[C]ode Goto [R]eferences" })
            -- Set vim motion for <Space> + c + i to display implementations to the code under the cursor
            vim.keymap.set("n", "<leader>ci", require("telescope.builtin").lsp_implementations,
                { desc = "[C]ode Goto [I]mplementations" })
            -- Set a vim motion for <Space> + c + <Shift>R to smartly rename the code under the cursor
            vim.keymap.set("n", "<leader>cR", vim.lsp.buf.rename, { desc = "[C]ode [R]ename" })
            -- Set a vim motion for <Space> + c + <Shift>D to go to where the code/object was declared in the project (class file)
            vim.keymap.set("n", "<leader>cD", vim.lsp.buf.declaration, { desc = "[C]ode Goto [D]eclaration" })
            -- Search document symbold
            vim.keymap.set("n", "<leader>cs", require("telescope.builtin").lsp_document_symbols,
                { desc = "[C]ode Document [S]ymbols" })
        end
    }
}
