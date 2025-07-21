return {
    "elmcgill/springboot-nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        "mfussenegger/nvim-jdtls"
    },
    config = function()
        -- Fix Windows path compatibility by patching multiple modules
        local ui_utils = require("springboot-nvim.ui.ui_utils")
        local utils = require("springboot-nvim.utils")
        
        -- Override package_text function to handle both Windows and Unix paths
        ui_utils.package_text = function(file_path)
            -- Normalize path separators for cross-platform compatibility
            local normalized_path = file_path:gsub("\\", "/")
            local src_index = string.find(normalized_path, "/src")
            if src_index then
                local base_package_path = string.sub(normalized_path, src_index + 15)
                if base_package_path and base_package_path ~= "" then
                    local package_path = base_package_path:gsub("/", ".")
                    -- Remove any trailing dots
                    package_path = package_path:gsub("%.+$", "")
                    return package_path .. '.'
                end
            end
            return ""
        end
        
        -- Fix java_path function for cross-platform compatibility
        local original_java_path = nil
        local java_path_fixed = false
        
        -- Override the generate_java_file function to fix Windows issues
        local original_generate_java_file = utils.generate_java_file
        utils.generate_java_file = function(buf, type, package_buf, class_buf)
            local package_input = vim.api.nvim_buf_get_lines(tonumber(package_buf), 0, -1, false)
            local package_text = table.concat(package_input)
            local class_input = vim.api.nvim_buf_get_lines(tonumber(class_buf), 0, -1, false)
            local class_text = table.concat(class_input)
            
            if(class_text ~= '') then
                -- Cross-platform java_path function
                local function java_path(full_path)
                    local normalized_path = full_path:gsub("\\", "/")
                    local pattern = "(.-)/java"
                    local match = normalized_path:match(pattern)
                    if match then
                        return match .. "/java"
                    end
                    -- Fallback: try to find src/main/java
                    local src_main_java = normalized_path:match("(.-/src/main)/java") 
                    if src_main_java then
                        return src_main_java .. "/java"
                    end
                    -- Last resort: assume current directory structure
                    return vim.fn.getcwd() .. "/src/main/java"
                end
                
                local dir = java_path(vim.api.nvim_buf_get_name(buf))
                -- Convert back to native path separators
                if vim.loop.os_uname().sysname == 'Windows_NT' then
                    dir = dir:gsub("/", "\\")
                end
                
                -- Make sure the directory for the new file ends properly
                local package_path = package_text:gsub("%.", "/")
                if(package_path:sub(-1, -1) ~= '/' and package_path ~= '') then
                    package_path = package_path .. "/"
                end
                
                -- Convert package path to native separators for directory creation
                local native_package_path = package_path
                if vim.loop.os_uname().sysname == 'Windows_NT' then
                    native_package_path = package_path:gsub("/", "\\")
                end
                
                -- Create directory cross-platform
                local full_dir_path = dir .. (vim.loop.os_uname().sysname == 'Windows_NT' and "\\" or "/") .. native_package_path
                if(vim.fn.isdirectory(full_dir_path) ~= 1) then
                    vim.fn.mkdir(full_dir_path, "p")
                end
                
                -- Strip trailing . for package import statement
                local package_import = package_text
                if(package_text:sub(-1, -1) == '.') then
                    package_import = string.sub(package_import, 1, -2)
                end
                
                -- Generate file content
                local class_boiler_plate = "package %s;\n\npublic class %s {\n\n}"
                local record_boiler_plate = "package %s;\n\npublic record %s(\n\n) {}"
                local interface_boiler_plate = "package %s;\n\npublic interface %s {\n\n}"
                local enum_boiler_plate = "package %s;\n\npublic enum %s {\n\n}"
                
                local java_file_content
                if(type == 'class') then
                    java_file_content = string.format(class_boiler_plate, package_import, class_text)
                elseif(type == 'record') then
                    java_file_content = string.format(record_boiler_plate, package_import, class_text)
                elseif(type == 'interface') then
                    java_file_content = string.format(interface_boiler_plate, package_import, class_text)
                elseif(type == 'enum') then
                    java_file_content = string.format(enum_boiler_plate, package_import, class_text)
                end
                
                -- Build file path with native separators
                local file_path = full_dir_path .. class_text .. ".java"
                
                local java_file = io.open(file_path, "r")
                if(java_file) then
                    print("Java file already exists")
                    java_file:close()
                    return
                else
                    java_file = io.open(file_path, "w")
                    if(java_file) then
                        java_file:write(java_file_content)
                        java_file:close()
                        print("Created: " .. file_path)
                    else
                        print('An issue occurred generating java file')
                        return
                    end
                end 
                
                vim.cmd('q!')
                vim.cmd('edit ' .. file_path)
            else
                print("Please specify a class name to continue")
            end
        end
        
        -- gain access to the springboot nvim plugin and its functions
        local springboot_nvim = require("springboot-nvim")

        -- run the setup function with improved configuration
        springboot_nvim.setup({
            -- Enable jdtls integration
            jdtls_name = 'jdtls',
            -- Configure popup window settings
            popup = {
                border = "rounded",
                winblend = 10,
            }
        })

        -- set a vim motion to <Space> + <Shift>J + r to run the spring boot project in a vim terminal
        vim.keymap.set('n', '<leader>Jr', function()
            springboot_nvim.boot_run()
        end, {desc = "[J]ava [R]un Spring Boot"})
        
        -- set a vim motion to <Space> + <Shift>J + c to open the generate class ui to create a class
        vim.keymap.set('n', '<leader>Jc', function()
            springboot_nvim.generate_class()
        end, {desc = "[J]ava Create [C]lass"})
        
        -- set a vim motion to <Space> + <Shift>J + i to open the generate interface ui to create an interface
        vim.keymap.set('n', '<leader>Ji', function()
            springboot_nvim.generate_interface()
        end, {desc = "[J]ava Create [I]nterface"})
        
        -- set a vim motion to <Space> + <Shift>J + e to open the generate enum ui to create an enum
        vim.keymap.set('n', '<leader>Je', function()
            springboot_nvim.generate_enum()
        end, {desc = "[J]ava Create [E]num"})
    end
}
