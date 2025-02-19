return {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'
  
      -- REQUIRED
      harpoon:setup()
      -- REQUIRED

      -- Set a vim motion to the tab key to open the harpoon menu to easily navigate frequented files
    --   vim.keymap.set("n", "<TAB>", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", {desc = "Harpoon Toggle Menu"})

      vim.keymap.set('n', '<leader>a', function()
        local id = MiniNotify.add("Harpooned file", 'INFO', 'Success')
        vim.defer_fn(function() MiniNotify.remove(id) end, 1000)
        harpoon:list():add()
      end, { desc = '[A]dd file to Harpoon' })
      vim.keymap.set('n', '<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = '[E]xplore Harpoon' })
  
      vim.keymap.set('n', '<C-1>', function()
        harpoon:list():select(1)
      end, { desc = '[1] Harpoon' })
      vim.keymap.set('n', '<C-2>', function()
        harpoon:list():select(2)
      end, { desc = '[2] Harpoon' })
      vim.keymap.set('n', '<C-3>', function()
        harpoon:list():select(3)
      end, { desc = '[3] Harpoon' })
      vim.keymap.set('n', '<C-4>', function()
        harpoon:list():select(4)
      end, { desc = '[4] Harpoon' })
  
      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set('n', '<C-S-P>', function()
        harpoon:list():prev()
      end, { desc = '[P]revious Harpoon' })
      vim.keymap.set('n', '<C-S-N>', function()
        harpoon:list():next()
      end, { desc = '[N]ext Harpoon' })
    end,
  }